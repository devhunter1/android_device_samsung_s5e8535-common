#include "EpicBaseOperator.h"

namespace epic {
	EpicBaseOperator::EpicBaseOperator(int scenario_id)
	{
		if (!prepareConnector())
			return;

		mConnector->alloc_request(scenario_id);
	}

	EpicBaseOperator::EpicBaseOperator(int *scenario_id_list, int len)
	{
		if (!prepareConnector())
			return;

		mConnector->alloc_request(scenario_id_list, len);
	}

	EpicBaseOperator::~EpicBaseOperator()
	{
	}

	bool EpicBaseOperator::doAction(int __unused cmd, void __unused *arg)
	{
		return true;
	}

	bool EpicBaseOperator::prepareConnector()
	{
		mConnector = std::make_shared<EpicConnector>();

		return (mConnector != nullptr);
	}
}
