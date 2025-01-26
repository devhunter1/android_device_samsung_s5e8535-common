#include "EpicRequest.h"
#include "EpicHandle.h"

#include <chrono>
#include <thread>
#include <sstream>

#include <dlfcn.h>
#include <unistd.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/sendfile.h>
#include <android/log.h>

namespace vendor {
namespace samsung_slsi {
namespace hardware {
namespace epic {
namespace V1_0 {
namespace implementation {
EpicRequest::EpicRequest() :
	so_handle(nullptr)
{
	if (sizeof(long) == sizeof(int))
		so_handle = dlopen("/vendor/lib/libepic_helper.so", RTLD_NOW);
	else
		so_handle = dlopen("/vendor/lib64/libepic_helper.so", RTLD_NOW);

	if (so_handle == nullptr) {
		pfn_init = nullptr;
		pfn_term = nullptr;
		pfn_alloc_request = nullptr;
		pfn_alloc_multi_request = nullptr;
		pfn_update_handle = nullptr;
		pfn_free_request = nullptr;
		pfn_acquire = nullptr;
		pfn_acquire_option = nullptr;
		pfn_acquire_multi_option = nullptr;
		pfn_release = nullptr;
		pfn_acquire_conditional = nullptr;
		pfn_release_conditional = nullptr;
		pfn_hint = nullptr;
		pfn_hint_release = nullptr;
		pfn_dump = nullptr;
		return;
	}

	pfn_init = (init_t)dlsym(so_handle, "epic_init");
	pfn_term = (term_t)dlsym(so_handle, "epic_term");
	pfn_alloc_request = (alloc_request_t)dlsym(so_handle, "epic_alloc_request_internal");
	pfn_alloc_multi_request = (alloc_multi_request_t)dlsym(so_handle, "epic_alloc_multi_request_internal");
	pfn_update_handle = (update_handle_t)dlsym(so_handle, "epic_update_handle_id_internal");
	pfn_free_request = (free_request_t)dlsym(so_handle, "epic_free_request_internal");
	pfn_acquire = (acquire_t)dlsym(so_handle, "epic_acquire_internal");
	pfn_acquire_option = (acquire_option_t)dlsym(so_handle, "epic_acquire_option_internal");
	pfn_acquire_multi_option = (acquire_multi_option_t)dlsym(so_handle, "epic_acquire_multi_option_internal");
	pfn_acquire_conditional = (acquire_conditional_t)dlsym(so_handle, "epic_acquire_conditional_internal");
	pfn_release_conditional = (release_conditional_t)dlsym(so_handle, "epic_release_conditional_internal");
	pfn_hint = (hint_t)dlsym(so_handle, "epic_perf_hint_internal");
	pfn_hint_release = (hint_t)dlsym(so_handle, "epic_hint_release_internal");
	pfn_release = (release_t)dlsym(so_handle, "epic_release_internal");
	pfn_dump = (dump_t)dlsym(so_handle, "epic_request_dumpstate_internal");

	if (pfn_init != nullptr)
		pfn_init();
}

EpicRequest::~EpicRequest()
{
	if (pfn_term != nullptr)
		pfn_term();

	dlclose(so_handle);
}

// Methods from ::hardware::samsung_slsi::hardware::epic::V1_0::IEpicRequest follow.
Return<sp<IEpicHandle>> EpicRequest::init(int32_t scenario_id) {
	if (pfn_alloc_request == nullptr)
		return nullptr;

	handleType req_handle = pfn_alloc_request(scenario_id);

	EpicHandle *ret_instance = new EpicHandle();
	ret_instance->set_pfn_finalize(pfn_free_request);

	sp<IEpicHandle> ret = ret_instance;
	ret->init(req_handle);

	return ret;
}

Return<sp<IEpicHandle>> EpicRequest::init_multi(const hidl_vec<int32_t>& scenario_id_list) {
	if (pfn_alloc_multi_request == nullptr)
		return nullptr;

	handleType req_handle = pfn_alloc_multi_request(scenario_id_list.data(), scenario_id_list.size());

	EpicHandle *ret_instance = new EpicHandle();
	ret_instance->set_pfn_finalize(pfn_free_request);

	sp<IEpicHandle> ret = ret_instance;
	ret->init(req_handle);

	return ret;
}

Return<uint32_t> EpicRequest::update_handle_id(const sp<IEpicHandle> &handle, const hidl_string &handle_id) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_update_handle == nullptr)
		return false;

	pfn_update_handle(req_handle, handle_id.c_str());
	return true;
}

Return<uint32_t> EpicRequest::acquire_lock(const sp<IEpicHandle> &handle) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_acquire == nullptr)
		return 0;

	return (uint32_t)pfn_acquire(req_handle);
}

Return<uint32_t> EpicRequest::release_lock(const sp<IEpicHandle> &handle) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_release == nullptr)
		return 0;

	return (uint32_t)pfn_release(req_handle);
}

Return<uint32_t> EpicRequest::acquire_lock_option(const sp<IEpicHandle> &handle, uint32_t value, uint32_t usec) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_acquire_option == nullptr)
		return 0;

	return (uint32_t)pfn_acquire_option(req_handle, value, usec);
}

Return<uint32_t> EpicRequest::acquire_lock_multi_option(const sp<IEpicHandle> &handle, const hidl_vec<uint32_t>& value_list, const hidl_vec<uint32_t>& usec_list) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_acquire_multi_option == nullptr)
		return 0;

	return (uint32_t)pfn_acquire_multi_option(req_handle, value_list.data(), usec_list.data(), value_list.size());
}

Return<uint32_t> EpicRequest::acquire_lock_conditional(const sp<IEpicHandle> &handle, const hidl_string &condition_name) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_acquire_conditional == nullptr)
		return 0;

	return (uint32_t)pfn_acquire_conditional(req_handle, condition_name.c_str(), condition_name.size());
}

Return<uint32_t> EpicRequest::release_lock_conditional(const sp<IEpicHandle> &handle, const hidl_string &condition_name) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_release_conditional == nullptr)
		return 0;

	return (uint32_t)pfn_release_conditional(req_handle, condition_name.c_str(), condition_name.size());
}

Return<uint32_t> EpicRequest::perf_hint(const sp<IEpicHandle> &handle, const hidl_string& name) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_hint == nullptr)
		return 0;

	return (uint32_t)pfn_hint(req_handle, name.c_str(), name.size());
}

Return<uint32_t> EpicRequest::hint_release(const sp<IEpicHandle> &handle, const hidl_string& name) {
	if (handle == nullptr)
		return 0;

	handleType req_handle = (handleType)handle->get_handle();

	if (req_handle == 0 ||
		pfn_hint_release == nullptr)
		return 0;

	return (uint32_t)pfn_hint_release(req_handle, name.c_str(), name.size());
}

Return<void> EpicRequest::debug(const hidl_handle& fd, const hidl_vec<hidl_string>& __unused options) {
	if (pfn_dump == nullptr)
		return Void();

	const native_handle_t* native_handle = fd.getNativeHandle();
	if (native_handle == nullptr || native_handle->numFds < 1)
		return Void();

	int dumpFd = native_handle->data[0];

	sp<IEpicHandle> handle = init(0);
	handleType req_handle = (handleType)handle->get_handle();

	std::ostringstream fmt;
	fmt << PATH_DIR_DUMP << PATH_FILE_DUMP;
	std::string &&path_dump = fmt.str();

	pfn_dump(req_handle, path_dump.c_str(), path_dump.length());
	std::this_thread::sleep_for(std::chrono::milliseconds(100));

	int requestDumpFd = -1, count_try = 0;
	for (count_try = 0; count_try < MAX_TRIES_DUMP; ++count_try) {
		requestDumpFd = open(path_dump.c_str(), O_RDONLY);
		if (requestDumpFd >= 0)
			break;

		std::this_thread::sleep_for(std::chrono::milliseconds(1));
	}

	if (count_try == MAX_TRIES_DUMP &&
		requestDumpFd == -1)
		return Void();

	bool lockHeld = false;
	for (count_try = 0; count_try < MAX_TRIES_DUMP; ++count_try) {
		if (flock(requestDumpFd, LOCK_EX) == 0) {
			lockHeld = true;
			break;
		}

		std::this_thread::sleep_for(std::chrono::milliseconds(1));
	}

	if (count_try == MAX_TRIES_DUMP &&
		!lockHeld) {
		close(requestDumpFd);
		return Void();
	}

	off_t file_size;
	file_size = lseek(requestDumpFd, 0, SEEK_END);
	lseek(requestDumpFd, 0, SEEK_SET);
	if (sendfile(dumpFd, requestDumpFd, 0, file_size) < 0)
		__android_log_print(ANDROID_LOG_INFO, "EpicHAL", "Couldn't send file content successfully!");
	if (flock(requestDumpFd, LOCK_UN) == -1)
		__android_log_print(ANDROID_LOG_INFO, "EpicHAL", "Couldn't release file lock!");
	close(requestDumpFd);
	unlink(path_dump.c_str());

	return Void();
}

// Methods from ::android::hidl::base::V1_0::IBase follow.
IEpicRequest* HIDL_FETCH_IEpicRequest(const char* /* name */) {
	return new EpicRequest();
}
//
}  // namespace implementation
}  // namespace V1_0
}  // namespace epic
}  // namespace hardware
}  // namespace samsung_slsi
}  // namespace vendor
