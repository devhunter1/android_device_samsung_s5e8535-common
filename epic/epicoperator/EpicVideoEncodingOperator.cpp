#include "EpicVideoEncodingOperator.h"

#include "EpicEnum.h"

namespace epic {
	EpicVideoEncodingOperator::EpicVideoEncodingOperator() :
		EpicBaseOperator(3),
		mConditionName("video_encoder")
	{
	}

	EpicVideoEncodingOperator::~EpicVideoEncodingOperator()
	{
	}

	bool EpicVideoEncodingOperator::doAction(int __unused cmd, void __unused *arg)
	{
		if (cmd == eAcquire)
			return mConnector->acquire_conditional(mConditionName);

		return false;
	}
}
