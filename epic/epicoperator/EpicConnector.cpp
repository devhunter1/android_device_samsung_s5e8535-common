#include "EpicConnector.h"

#include <vector>

#include <android/log.h>

#include <dlfcn.h>
#include <unistd.h>

using ::android::hardware::hidl_vec;

namespace epic {
	EpicConnector::EpicConnector()
	{
	}

	EpicConnector::~EpicConnector()
	{
	}

	void EpicConnector::alloc_request(int scenario_id)
	{
		getService();
		if (mRequest == nullptr)
			return;

		mHandle = mRequest->init(scenario_id);
	}

	void EpicConnector::alloc_request(int *scenario_id_list, int len)
	{
		getService();
		if (mRequest == nullptr)
			return;

		std::vector<int32_t> id_vec(scenario_id_list, scenario_id_list + len);
		mHandle = mRequest->init_multi(id_vec);
	}

	bool EpicConnector::acquire()
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		return mRequest->acquire_lock(mHandle);
	}

	bool EpicConnector::acquire(unsigned int value, unsigned int usec)
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		return mRequest->acquire_lock_option(mHandle, value, usec);
	}

	bool EpicConnector::acquire(unsigned int *value, unsigned int *usec, int len)
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		std::vector<unsigned int> value_vec(value, value + len);
		std::vector<unsigned int> usec_vec(usec, usec + len);

		return mRequest->acquire_lock_multi_option(mHandle, value_vec, usec_vec);
	}

	bool EpicConnector::acquire_conditional(std::string &condition_name)
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		return mRequest->acquire_lock_conditional(mHandle, condition_name.c_str());
	}

	bool EpicConnector::release()
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		return mRequest->release_lock(mHandle);
	}

	bool EpicConnector::release_conditional(std::string &condition_name)
	{
		if (mRequest == nullptr ||
			mHandle == nullptr)
			return false;

		return mRequest->release_lock_conditional(mHandle, condition_name.c_str());
	}

	void EpicConnector::getService()
	{
		mRequest = IEpicRequest::getService();
		if (mRequest == nullptr)
			__android_log_print(ANDROID_LOG_INFO, "EPICOPERATOR", "Couldn't get service EPIC HIDL!");
	}
}
