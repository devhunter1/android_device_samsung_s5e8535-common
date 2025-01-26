#pragma once

namespace epic {
	class IEpicOperator {
	public:
		IEpicOperator() = default;
		virtual ~IEpicOperator() {};

		virtual bool doAction(int cmd, void *arg) = 0;
	};
}
