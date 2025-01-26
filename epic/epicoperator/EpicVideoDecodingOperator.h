#pragma once

#include "IEpicOperator.h"
#include "EpicBaseOperator.h"

namespace epic {
	class EpicVideoDecodingOperator : public EpicBaseOperator {
	public:
		EpicVideoDecodingOperator();
		virtual ~EpicVideoDecodingOperator() override;

		virtual bool doAction(int cmd, void *arg) override;

	private:
		std::string mConditionName;
	};
}
