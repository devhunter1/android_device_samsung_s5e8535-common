#include "EpicCommonMultiOperator.h"

#include "EpicEnum.h"

namespace epic {
	EpicCommonMultiOperator::EpicCommonMultiOperator() :
		EpicBaseOperator(0)
	{
	}

	EpicCommonMultiOperator::EpicCommonMultiOperator(int *scenario_id_list, int len) :
		EpicBaseOperator(scenario_id_list, len)
	{
	}

	EpicCommonMultiOperator::~EpicCommonMultiOperator()
	{
	}

	bool EpicCommonMultiOperator::doAction(int __unused cmd, void *arg)
	{
		switch (cmd) {
		case eAcquire:
			return mConnector->acquire();
		case eRelease:
			return mConnector->release();
		case eAcquireOption:
			return doAcquireOption(arg);
		default:
			return false;
		}

		return false;
	}

	bool EpicCommonMultiOperator::doAcquireOption(void *arg)
	{
		if (arg == nullptr)
			return false;

		unsigned int *arg_array = reinterpret_cast<unsigned int *>(arg);
		unsigned int len_array = *arg_array;

		arg_array++;

		return mConnector->acquire(arg_array, arg_array + len_array, len_array);
	}
}
