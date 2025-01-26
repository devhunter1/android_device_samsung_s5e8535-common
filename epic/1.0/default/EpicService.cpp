/*
 * Copyright (C) 2016 The Android Open Source Project
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

#ifdef LOG_TAG
#undef LOG_TAG
#endif
#define LOG_TAG "vendor.samsung_slsi.hardware.epic@1.0-service"

#include <android/log.h>
#include <hidl/HidlTransportSupport.h>
#include <binder/ProcessState.h>

#include <hidl/LegacySupport.h>
#include "EpicRequest.h"

using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::hardware::defaultPassthroughServiceImplementation;
using android::sp;

using vendor::samsung_slsi::hardware::epic::V1_0::IEpicRequest;
using vendor::samsung_slsi::hardware::epic::V1_0::implementation::EpicRequest;

int main()
{
	android::ProcessState::initWithDriver("/dev/vndbinder");

	ALOGI("Epic Service started!");
	return defaultPassthroughServiceImplementation<IEpicRequest>();
}
