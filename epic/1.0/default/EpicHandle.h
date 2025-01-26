#ifndef VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICHANDLE_H
#define VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICHANDLE_H

#include <vendor/samsung_slsi/hardware/epic/1.0/IEpicHandle.h>
#include <hidl/MQDescriptor.h>
#include <hidl/Status.h>
#include <hidl/HidlSupport.h>

#include "EpicType.h"

namespace vendor {
	namespace samsung_slsi {
		namespace hardware {
			namespace epic {
				namespace V1_0 {
					namespace implementation {

						using ::android::hardware::hidl_array;
						using ::android::hardware::hidl_memory;
						using ::android::hardware::hidl_string;
						using ::android::hardware::hidl_vec;
						using ::android::hardware::Return;
						using ::android::hardware::Void;
						using ::android::sp;

						struct EpicHandle : public IEpicHandle {
							EpicHandle();
							virtual ~EpicHandle();

							// Methods from ::vendor::samsung_slsi::hardware::epic::V1_0::IEpicHandle follow.
							Return<void> init(int64_t request_handle) override;
							Return<int64_t> get_handle() override;

							Return<void> diagonostic() override;

							Return<void> set_pfn_finalize(free_request_t pfn);

							long mReqHandle;
							free_request_t pfn_free_request;
						};
					}  // namespace implementation
				}  // namespace V1_0
			}  // namespace epic
		}  // namespace hardware
	}  // namespace samsung_slsi
}  // namespace vendor

#endif  // VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICHANDLE_H
