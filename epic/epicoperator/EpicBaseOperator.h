#pragma once

#include <memory>

#include "IEpicOperator.h"
#include "EpicConnector.h"

namespace epic {
	class EpicBaseOperator : public IEpicOperator {
	public:
		virtual ~EpicBaseOperator();

		virtual bool doAction(int cmd, void *arg) override;

	protected:
		EpicBaseOperator(int scenario_id);
		EpicBaseOperator(int *scenario_id, int len);

		std::shared_ptr<EpicConnector> mConnector;

	private:
		bool prepareConnector();
	};
}
