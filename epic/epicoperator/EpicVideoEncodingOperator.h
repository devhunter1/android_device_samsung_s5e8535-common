#pragma once

#include "IEpicOperator.h"
#include "EpicBaseOperator.h"

namespace epic {
	class EpicVideoEncodingOperator : public EpicBaseOperator {
	public:
		EpicVideoEncodingOperator();
		virtual ~EpicVideoEncodingOperator() override;

		virtual bool doAction(int cmd, void *arg) override;

	private:
		std::string mConditionName;
	};
}
