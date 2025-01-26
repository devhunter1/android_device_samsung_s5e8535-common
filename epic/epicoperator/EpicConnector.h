#pragma once

#include <vendor/samsung_slsi/hardware/epic/1.0/IEpicRequest.h>
using ::vendor::samsung_slsi::hardware::epic::V1_0::IEpicRequest;
using ::vendor::samsung_slsi::hardware::epic::V1_0::IEpicHandle;
using ::android::sp;

#include <string>

namespace epic {
	class EpicConnector {
	public:
		EpicConnector();
		~EpicConnector();

		void alloc_request(int scenario_id);
		void alloc_request(int *scenario_id_list, int len);
		void free_request();
		bool acquire();
		bool acquire(unsigned int value, unsigned int usec);
		bool acquire(unsigned int *value, unsigned int *usec, int len);
		bool acquire_conditional(std::string &condition_name);
		bool release();
		bool release_conditional(std::string &condition_name);

	private:
		void getService();

		sp<IEpicRequest> mRequest;
		sp<IEpicHandle> mHandle;
	};
}
