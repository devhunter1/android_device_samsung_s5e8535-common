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

#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <log/log.h>

#include "BluetoothHci.h"

using ::aidl::android::hardware::bluetooth::hal::IBluetoothHci_addService;
using ::aidl::android::hardware::bluetooth::impl::BluetoothHci;

int main(int /* argc */, char** /* argv */) {
  ALOGI("Bluetooth HAL starting");
  if (!ABinderProcess_setThreadPoolMaxThreadCount(0)) {
    ALOGI("failed to set thread pool max thread count");
    return 1;
  }

  IBluetoothHci_addService(new BluetoothHci());
  ABinderProcess_joinThreadPool();
  return 0;
}
