#include "EpicVideoDecodingOperator.h"

#include "EpicEnum.h"

namespace epic {
	EpicVideoDecodingOperator::EpicVideoDecodingOperator() :
		EpicBaseOperator(30000),
		mConditionName("video_decoder")
	{
	}

	EpicVideoDecodingOperator::~EpicVideoDecodingOperator()
	{
	}

	bool EpicVideoDecodingOperator::doAction(int __unused cmd, void __unused *arg)
	{
		switch (cmd) {
		case eAcquire:
			return mConnector->acquire_conditional(mConditionName);
		case eRelease:
			return mConnector->release_conditional(mConditionName);
		default:
			return false;
		}

		return false;
	}
}
