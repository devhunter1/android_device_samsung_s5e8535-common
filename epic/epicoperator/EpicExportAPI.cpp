#include <memory>
#include <cstring>

#include <unistd.h>

#include <OperatorFactory.h>

using namespace epic;

#ifdef __cplusplus
extern "C" {
#endif

long epic_alloc_request_internal(int id)
{
	return reinterpret_cast<long>(createScenarioOperator(eCommon, id));
}

void epic_free_request_internal(long handle)
{
	IEpicOperator *handle_operator = reinterpret_cast<IEpicOperator *>(handle);

	if (handle_operator == nullptr)
		return;

	delete handle_operator;
}

bool epic_acquire_internal(long handle)
{
	IEpicOperator *handle_operator = reinterpret_cast<IEpicOperator *>(handle);

	if (handle_operator == nullptr)
		return false;

	return handle_operator->doAction(eAcquire, nullptr);
}

bool epic_acquire_option_internal(long handle, unsigned int value, unsigned int usec)
{
	IEpicOperator *handle_operator = reinterpret_cast<IEpicOperator *>(handle);

	if (handle_operator == nullptr)
		return false;

	int32_t arg_array[2] = { static_cast<int32_t>(value), static_cast<int32_t>(usec) };
	return handle_operator->doAction(eAcquireOption, arg_array);
}

bool epic_acquire_option_multi_internal(long handle, unsigned int *value, unsigned int *usec, int len)
{
	IEpicOperator *handle_operator = reinterpret_cast<IEpicOperator *>(handle);

	if (handle_operator == nullptr ||
		len == 0)
		return false;

	std::unique_ptr<int32_t[]> arg_ptr = std::make_unique<int32_t[]>(2 * len + 1);

	arg_ptr[0] = len;
	memcpy(arg_ptr.get() + 1, value, len * sizeof(int32_t));
	memcpy(arg_ptr.get() + len + 1, usec, len * sizeof(int32_t));

	return handle_operator->doAction(eAcquireOption, arg_ptr.get());
}

bool epic_release_internal(long handle)
{
	IEpicOperator *handle_operator = reinterpret_cast<IEpicOperator *>(handle);

	if (handle_operator == nullptr)
		return false;

	return handle_operator->doAction(eRelease, nullptr);
}

#ifdef __cplusplus
}
#endif
