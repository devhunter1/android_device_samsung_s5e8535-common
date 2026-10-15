//
// SPDX-FileCopyrightText: The LineageOS Project
// SPDX-License-Identifier: Apache-2.0
//

#include <dlfcn.h>

#include <cstddef>

#include <log/log.h>
#include <telephony/ril.h>

#ifndef REAL_LIB_NAME
#error "REAL_LIB_NAME must be defined by Android.bp"
#endif

#ifndef RIL_REQUEST_SEND_SMS
#define RIL_REQUEST_SEND_SMS 25
#endif

#ifndef RIL_REQUEST_SEND_SMS_EXPECT_MORE
#define RIL_REQUEST_SEND_SMS_EXPECT_MORE 26
#endif

static constexpr char kRealPath[] = "/vendor/lib64/" REAL_LIB_NAME;

using SamsungRequestFunc = void (*)(int, void*, size_t, RIL_Token, RIL_SOCKET_ID);

// Samsung extends RIL_RadioFunctions after onRequest. Only describe the
// common prefix so the private callbacks remain in the real table.
struct SamsungRilFunctionsPrefix {
    int version;
    SamsungRequestFunc onRequest;
};

static_assert(offsetof(SamsungRilFunctionsPrefix, onRequest) == sizeof(void*),
              "unexpected Samsung RIL function-table prefix");

using RilInit = const RIL_RadioFunctions* (*)(const RIL_Env*, int, char**);

static void* gRealHandle = nullptr;
static SamsungRequestFunc gRealOnRequest = nullptr;

static void* getRealHandle() {
    if (gRealHandle != nullptr) {
        return gRealHandle;
    }

    ALOGI("sec-ril-shim: loading %s", kRealPath);
    gRealHandle = dlopen(kRealPath, RTLD_NOW);
    if (gRealHandle == nullptr) {
        ALOGE("sec-ril-shim: dlopen failed: %s", dlerror());
    }

    return gRealHandle;
}

static RilInit getRealInit(const char* name) {
    void* realHandle = getRealHandle();
    if (realHandle == nullptr) {
        return nullptr;
    }

    dlerror();
    auto realInit = reinterpret_cast<RilInit>(dlsym(realHandle, name));
    const char* error = dlerror();
    if (error != nullptr) {
        ALOGE("sec-ril-shim: dlsym %s failed: %s", name, error);
        return nullptr;
    }

    return realInit;
}

static bool isCsSmsRequest(int request) {
    return request == RIL_REQUEST_SEND_SMS || request == RIL_REQUEST_SEND_SMS_EXPECT_MORE;
}

static void shimOnRequest(int request, void* data, size_t datalen, RIL_Token token,
                          RIL_SOCKET_ID socketId) {
    if (isCsSmsRequest(request) && data != nullptr && datalen >= 2 * sizeof(char*)) {
        const char** smsData = static_cast<const char**>(data);
        const char* smsc = smsData[0];
        const char* pdu = smsData[1];

        if (pdu != nullptr) {
            const char* fixedSmsData[] = {
                    nullptr,
                    pdu,
            };

            ALOGI("sec-ril-shim: request %d: forcing CS SMSC NULL, "
                  "original smsc=%s",
                  request, smsc != nullptr ? smsc : "null");
            gRealOnRequest(request, const_cast<char**>(fixedSmsData), sizeof(fixedSmsData), token,
                           socketId);
            return;
        }

        ALOGW("sec-ril-shim: request %d: null PDU", request);
    }

    gRealOnRequest(request, data, datalen, token, socketId);
}

extern "C" const RIL_RadioFunctions* RIL_Init(const RIL_Env* env, int argc, char** argv) {
    RilInit realRilInit = getRealInit("RIL_Init");
    if (realRilInit == nullptr) {
        return nullptr;
    }

    const RIL_RadioFunctions* real = realRilInit(env, argc, argv);
    if (real == nullptr) {
        ALOGE("sec-ril-shim: invalid real RIL function table");
        return real;
    }

    auto* realPrefix =
            reinterpret_cast<SamsungRilFunctionsPrefix*>(const_cast<RIL_RadioFunctions*>(real));
    if (realPrefix->onRequest == nullptr) {
        ALOGE("sec-ril-shim: real onRequest is null");
        return real;
    }

    if (realPrefix->onRequest != shimOnRequest) {
        gRealOnRequest = realPrefix->onRequest;
        realPrefix->onRequest = shimOnRequest;
    } else if (gRealOnRequest == nullptr) {
        ALOGE("sec-ril-shim: missing saved real onRequest");
        return nullptr;
    }

    ALOGI("sec-ril-shim: installed in-place CS SMSC NULL shim");
    return real;
}

extern "C" const RIL_RadioFunctions* RIL_SAP_Init(const RIL_Env* env, int argc, char** argv) {
    RilInit realSapInit = getRealInit("RIL_SAP_Init");
    if (realSapInit == nullptr) {
        return nullptr;
    }

    return realSapInit(env, argc, argv);
}
