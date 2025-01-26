#include "IEpicOperator.h"

#include "EpicEnum.h"
#include "EpicCommonOperator.h"
#include "EpicCommonMultiOperator.h"
#include "EpicVideoEncodingOperator.h"
#include "EpicVideoDecodingOperator.h"

#ifdef __cplusplus
extern "C" {
#endif

void * createOperator(int operator_id)
{
	switch (operator_id) {
	case eVideoEncoding:
		return new epic::EpicVideoEncodingOperator();
	case eVideoDecoding:
		return new epic::EpicVideoDecodingOperator();
	default:
		return nullptr;
	}

	return nullptr;
}

void * createScenarioOperator(int operator_id, int scenario_id)
{
	switch (operator_id) {
	case eCommon:
		return new epic::EpicCommonOperator(scenario_id);
	default:
		return nullptr;
	}

	return nullptr;
}

void * createScenarioMultiOperator(int operator_id, int *scenario_id_list, int len)
{
	if (len == 1)
		return createScenarioOperator(operator_id, *scenario_id_list);

	switch (operator_id) {
	case eCommon:
		return new epic::EpicCommonMultiOperator(scenario_id_list, len);
	default:
		return nullptr;
	}

	return nullptr;
}

#ifdef __cplusplus
}
#endif
