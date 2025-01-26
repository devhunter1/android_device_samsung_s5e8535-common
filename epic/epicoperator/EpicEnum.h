#pragma once

enum eOperator {
	eCommon,
        eVideoEncoding,
        eVideoDecoding,
};

enum eCommand {
	eNone,
	eAcquire,
	eRelease,
	eAcquireOption,
	eAcquireConditional,
	eReleaseConditional,
};
