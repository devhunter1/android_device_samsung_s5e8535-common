#ifndef VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICREQUEST_H
#define VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICREQUEST_H

#include <vendor/samsung_slsi/hardware/epic/1.0/IEpicRequest.h>
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
						using ::android::hardware::hidl_handle;
						using ::android::hardware::Return;
						using ::android::hardware::Void;
						using ::android::sp;

						struct EpicRequest : public IEpicRequest {
							EpicRequest();
							virtual ~EpicRequest();

							// Methods from ::vendor::samsung_slsi::hardware::epic::V1_0::IEpicRequest follow.

							Return<sp<IEpicHandle>> init(int32_t scenario_id) override;
							Return<sp<IEpicHandle>> init_multi(const hidl_vec<int32_t>& scenario_id_list) override;
							Return<uint32_t> update_handle_id(const sp<IEpicHandle> &handle, const hidl_string &handle_id) override;
							Return<uint32_t> acquire_lock(const sp<IEpicHandle> &handle) override;
							Return<uint32_t> release_lock(const sp<IEpicHandle> &handle) override;
							Return<uint32_t> acquire_lock_option(const sp<IEpicHandle> &handle, uint32_t value, uint32_t usec) override;
							Return<uint32_t> acquire_lock_multi_option(const sp<IEpicHandle> &handle, const hidl_vec<uint32_t>& value_list, const hidl_vec<uint32_t>& usec_list) override;
							Return<uint32_t> acquire_lock_conditional(const sp<IEpicHandle> &handle, const hidl_string &condition_name);
							Return<uint32_t> release_lock_conditional(const sp<IEpicHandle> &handle, const hidl_string &condition_name);
							Return<uint32_t> perf_hint(const sp<IEpicHandle> &handle, const hidl_string& name) override;
							Return<uint32_t> hint_release(const sp<IEpicHandle> &handle, const hidl_string& name) override;

							Return<void> debug(const hidl_handle& fd, const hidl_vec<hidl_string>& options) override;

							void *so_handle;

							init_t pfn_init;
							term_t pfn_term;
							alloc_request_t pfn_alloc_request;
							alloc_multi_request_t pfn_alloc_multi_request;
							update_handle_t pfn_update_handle;
							free_request_t pfn_free_request;
							acquire_t pfn_acquire;
							acquire_option_t pfn_acquire_option;
							acquire_multi_option_t pfn_acquire_multi_option;
							acquire_conditional_t pfn_acquire_conditional;
							release_conditional_t pfn_release_conditional;
							hint_t pfn_hint;
							hint_release_t pfn_hint_release;
							release_t pfn_release;
							dump_t pfn_dump;

							constexpr static const char *PATH_DIR_DUMP = "/data/vendor/epic/";
							constexpr static const char *PATH_FILE_DUMP = "epic.dump";
							constexpr static const int MAX_TRIES_DUMP = 1000;
						};

						// FIXME: most likely delete, this is only for passthrough implementations
						extern "C" IEpicRequest* HIDL_FETCH_IEpicRequest(const char* name);

					}  // namespace implementation
				}  // namespace V1_0
			}  // namespace epic
		}  // namespace hardware
	}  // namespace samsung_slsi
}  // namespace vendor

#endif  // VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICREQUEST_H
