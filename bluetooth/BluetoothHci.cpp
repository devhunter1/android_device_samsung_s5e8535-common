/*
 * Copyright 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "android.hardware.bluetooth-service.exynos"

#include "BluetoothHci.h"

#include <cutils/properties.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <poll.h>
#include <string.h>
#include <sys/uio.h>
#include <termios.h>

#include "log/log.h"

namespace {
int SetTerminalRaw(int fd) {
  termios terminal_settings;
  int rval = tcgetattr(fd, &terminal_settings);
  if (rval < 0) {
    return rval;
  }
  cfmakeraw(&terminal_settings);
  rval = tcsetattr(fd, TCSANOW, &terminal_settings);
  return rval;
}
}  // namespace

using namespace ::android::hardware::bluetooth::hci;
using namespace ::android::hardware::bluetooth::async;
using aidl::android::hardware::bluetooth::hal::Status;

namespace aidl::android::hardware::bluetooth::impl {

std::optional<std::string> GetSystemProperty(const std::string& property) {
  std::array<char, PROPERTY_VALUE_MAX> value_array{0};
  auto value_len = property_get(property.c_str(), value_array.data(), nullptr);
  if (value_len <= 0) {
    return std::nullopt;
  }
  return std::string(value_array.data(), value_len);
}

bool starts_with(const std::string& str, const std::string& prefix) {
  return str.compare(0, prefix.length(), prefix) == 0;
}

BluetoothHci::BluetoothHci(const std::string& dev_path) {
  char property_bytes[PROPERTY_VALUE_MAX];
  property_get("vendor.ser.bt-uart", property_bytes, dev_path.c_str());
  mDevPath = std::string(property_bytes);
}

int BluetoothHci::getFdFromDevPath() {
  int fd = open(mDevPath.c_str(), O_RDWR);
  if (fd < 0) {
    ALOGE("Could not connect to bt: %s (%s)", mDevPath.c_str(),
          strerror(errno));
    return fd;
  }
  if (int ret = SetTerminalRaw(fd) < 0) {
    ALOGI("Could not make %s a raw terminal %d(%s)", mDevPath.c_str(), ret,
          strerror(errno));
  }
  return fd;
}

void BluetoothHci::reset() {
  // Send a reset command and wait until the command complete comes back.

  std::vector<uint8_t> reset = {0x03, 0x0c, 0x00};

  auto resetPromise = std::make_shared<std::promise<void>>();
  auto resetFuture = resetPromise->get_future();

  mH4 = std::make_shared<H4Protocol>(
      mFd,
      [](const std::vector<uint8_t>& raw_command) {
        ALOGI("Discarding %d bytes with command type",
              static_cast<int>(raw_command.size()));
      },
      [](const std::vector<uint8_t>& raw_acl) {
        ALOGI("Discarding %d bytes with acl type",
              static_cast<int>(raw_acl.size()));
      },
      [](const std::vector<uint8_t>& raw_sco) {
        ALOGI("Discarding %d bytes with sco type",
              static_cast<int>(raw_sco.size()));
      },
      [resetPromise](const std::vector<uint8_t>& raw_event) {
        std::vector<uint8_t> reset_complete = {0x0e, 0x04, 0x01,
                                               0x03, 0x0c, 0x00};
        bool valid = raw_event.size() == 6 &&
                     raw_event[0] == reset_complete[0] &&
                     raw_event[1] == reset_complete[1] &&
                     // Don't compare the number of packets field.
                     raw_event[3] == reset_complete[3] &&
                     raw_event[4] == reset_complete[4] &&
                     raw_event[5] == reset_complete[5];
        if (valid) {
          resetPromise->set_value();
        } else {
          ALOGI("Discarding %d bytes with event type",
                static_cast<int>(raw_event.size()));
        }
      },
      [](const std::vector<uint8_t>& raw_iso) {
        ALOGI("Discarding %d bytes with iso type",
              static_cast<int>(raw_iso.size()));
      },
      [this]() {
        ALOGI("HCI socket device disconnected while waiting for reset");
        mFdWatcher.StopWatchingFileDescriptors();
      });
  mFdWatcher.WatchFdForNonBlockingReads(mFd,
                                        [this](int) { mH4->OnDataReady(); });

  send(PacketType::COMMAND, reset);
  auto status = resetFuture.wait_for(std::chrono::seconds(1));
  mFdWatcher.StopWatchingFileDescriptors();
  if (status == std::future_status::ready) {
    ALOGI("HCI Reset successful");
  } else {
    ALOGE("HCI Reset Response not received in one second");
  }

  resetPromise.reset();
}

void BluetoothHci::initialize(
    const std::shared_ptr<hal::IBluetoothHciCallbacks>& cb) {
  ALOGI(__func__);

  if (cb == nullptr) {
    ALOGE("cb == nullptr! -> Unable to call initializationComplete(ERR)");
    abort();
  }

  HalState old_state = HalState::READY;
  {
    std::lock_guard<std::mutex> guard(mStateMutex);
    if (mState != HalState::READY) {
      old_state = mState;
    } else {
      mState = HalState::INITIALIZING;
    }
  }

  if (old_state != HalState::READY) {
    ALOGE("initialize: Unexpected State %d", static_cast<int>(old_state));
    close();
    cb->initializationComplete(Status::ALREADY_INITIALIZED);
  }

  mCb = cb;
  management_.reset(new NetBluetoothMgmt);
  mFd = management_->openHci();
  if (mFd < 0) {
    management_.reset();

    ALOGI("Unable to open Linux interface, trying default path.");
    mFd = getFdFromDevPath();
    if (mFd < 0) {
      mState = HalState::READY;
      cb->initializationComplete(Status::UNABLE_TO_OPEN_INTERFACE);
    }
  }

  // TODO: HCI Reset on emulators since the bluetooth controller
  // cannot be powered on/off during the HAL setup; and the stack
  // might received spurious packets/events during boottime.
  // Proper solution would be to use bt-virtio or vsock to better
  // control the link to rootcanal and the controller lifetime.
  const std::string kBoardProperty = "ro.product.board";
  const std::string kCuttlefishBoard = "cutf";
  auto board_name = GetSystemProperty(kBoardProperty);
  if (board_name.has_value() && (
        starts_with(board_name.value(), "cutf") ||
        starts_with(board_name.value(), "goldfish"))) {
    reset();
  }

  mH4 = std::make_shared<H4Protocol>(
      mFd,
      [](const std::vector<uint8_t>& /* raw_command */) {
        LOG_ALWAYS_FATAL("Unexpected command!");
      },
      [this](const std::vector<uint8_t>& raw_acl) {
        mCb->aclDataReceived(raw_acl);
      },
      [this](const std::vector<uint8_t>& raw_sco) {
        mCb->scoDataReceived(raw_sco);
      },
      [this](const std::vector<uint8_t>& raw_event) {
        mCb->hciEventReceived(raw_event);
      },
      [this](const std::vector<uint8_t>& raw_iso) {
        mCb->isoDataReceived(raw_iso);
      },
      [this]() {
        ALOGI("HCI socket device disconnected");
        mFdWatcher.StopWatchingFileDescriptors();
      });
  mFdWatcher.WatchFdForNonBlockingReads(mFd,
                                        [this](int) { mH4->OnDataReady(); });

  {
    std::lock_guard<std::mutex> guard(mStateMutex);
    mState = HalState::ONE_CLIENT;
  }
  ALOGI("initialization complete");
  mCb->initializationComplete(Status::SUCCESS);
}

void BluetoothHci::close() {
  ALOGI(__func__);
  {
    std::lock_guard<std::mutex> guard(mStateMutex);
    if (mState != HalState::ONE_CLIENT) {
      LOG_ALWAYS_FATAL_IF(mState == HalState::INITIALIZING,
                          "mState is INITIALIZING");
      ALOGI("Already closed");
    }
    mState = HalState::CLOSING;
  }

  mFdWatcher.StopWatchingFileDescriptors();

  if (management_) {
    management_->closeHci();
  } else {
    ::close(mFd);
  }

  {
    std::lock_guard<std::mutex> guard(mStateMutex);
    mState = HalState::READY;
    mH4 = nullptr;
  }
}

void BluetoothHci::clientDied() {
  ALOGI(__func__);
  close();
}

void BluetoothHci::sendHciCommand(const std::vector<uint8_t>& packet) {
  return send(PacketType::COMMAND, packet);
}

void BluetoothHci::sendAclData(const std::vector<uint8_t>& packet) {
  return send(PacketType::ACL_DATA, packet);
}

void BluetoothHci::sendScoData(const std::vector<uint8_t>& packet) {
  return send(PacketType::SCO_DATA, packet);
}

void BluetoothHci::sendIsoData(const std::vector<uint8_t>& packet) {
  return send(PacketType::ISO_DATA, packet);
}

void BluetoothHci::send(PacketType type, const std::vector<uint8_t>& v) {
  if (v.empty()) {
    ALOGE("Packet is empty, no data was found to be sent");
    abort();
  }

  std::lock_guard<std::mutex> guard(mStateMutex);
  if (mH4 == nullptr) {
    ALOGE("Illegal State");
    abort();
  }

  mH4->Send(type, v);
}

}  // namespace aidl::android::hardware::bluetooth::impl
