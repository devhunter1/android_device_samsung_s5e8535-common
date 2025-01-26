#include "EpicCommonOperator.h"

#include "EpicEnum.h"

namespace epic {
	EpicCommonOperator::EpicCommonOperator() :
		EpicBaseOperator(0)
	{
	}

	EpicCommonOperator::EpicCommonOperator(int scenario_id) :
		EpicBaseOperator(scenario_id)
	{
	}

	EpicCommonOperator::~EpicCommonOperator()
	{
	}

	bool EpicCommonOperator::doAction(int __unused cmd, void *arg)
	{
		switch (cmd) {
		case eAcquire:
			return mConnector->acquire();
		case eRelease:
			return mConnector->release();
		case eAcquireOption:
			return doAcquireOption(arg);
		case eAcquireConditional:
			return doConditional(&EpicConnector::acquire_conditional, arg);
		case eReleaseConditional:
			return doConditional(&EpicConnector::release_conditional, arg);
		default:
			return false;
		}

		return false;
	}

	bool EpicCommonOperator::doAcquireOption(void *arg)
	{
		if (arg == nullptr)
			return false;

		unsigned int *arg_array = reinterpret_cast<unsigned int *>(arg);

		return mConnector->acquire(arg_array[0], arg_array[1]);
	}

	bool EpicCommonOperator::doConditional(bool (EpicConnector::*func_conditional)(std::string &), void *arg)
	{
		if (arg == nullptr)
			return false;

		std::string arg_string(reinterpret_cast<char *>(arg));
		return ((*mConnector).*func_conditional)(arg_string);
	}
}
