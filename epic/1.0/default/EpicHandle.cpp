#include "EpicHandle.h"

namespace vendor {
	namespace samsung_slsi {
		namespace hardware {
			namespace epic {
				namespace V1_0 {
					namespace implementation {
						EpicHandle::EpicHandle() :
							mReqHandle(0),
							pfn_free_request(nullptr)
						{
						}

						EpicHandle::~EpicHandle()
						{
							if (mReqHandle == 0)
								return;

							if (pfn_free_request != nullptr)
								pfn_free_request(mReqHandle);
						}

						// Methods from ::vendor::samsung_slsi::hardware::epic::V1_0::IEpicHandle follow.
						Return<void> EpicHandle::init(int64_t request_handle) {
							mReqHandle = static_cast<long>(request_handle);

							return Void();
						}

						Return<int64_t> EpicHandle::get_handle() {
							return static_cast<int64_t>(mReqHandle);
						}

						Return<void> EpicHandle::diagonostic() {
							return Void();
						}

						Return<void> EpicHandle::set_pfn_finalize(free_request_t pfn)
						{
							pfn_free_request = pfn;
							return Void();
						}
					}  // namespace implementation
				}  // namespace V1_0
			}  // namespace epic
		}  // namespace interfaces
	}  // namespace samsung_slsi
}  // namespace hardware
