//
// SPDX-FileCopyrightText: The LineageOS Project
// SPDX-License-Identifier: Apache-2.0
//

#include <dlfcn.h>

#include <cstddef>
#include <mutex>
#include <string>
#include <unordered_map>

#include <log/log.h>
#include <telephony/ril.h>

#ifndef REAL_LIB_NAME
#error "REAL_LIB_NAME must be defined by Android.bp"
#endif

#ifndef RIL_REQUEST_GET_SMSC_ADDRESS
#define RIL_REQUEST_GET_SMSC_ADDRESS 100
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
static const RIL_Env* gRealEnv = nullptr;
static RIL_Env gShimEnv;

static std::mutex gTokenMapMutex;
static std::unordered_map<RIL_Token, int> gTokenRequestMap;

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

static int parseHexByte(const std::string& str, size_t start) {
    if (start + 2 > str.length()) {
        return -1;
    }
    char c1 = str[start];
    char c2 = str[start + 1];
    int val1 = (c1 >= '0' && c1 <= '9')   ? (c1 - '0')
               : (c1 >= 'a' && c1 <= 'f') ? (c1 - 'a' + 10)
               : (c1 >= 'A' && c1 <= 'F') ? (c1 - 'A' + 10)
                                          : -1;
    int val2 = (c2 >= '0' && c2 <= '9')   ? (c2 - '0')
               : (c2 >= 'a' && c2 <= 'f') ? (c2 - 'a' + 10)
               : (c2 >= 'A' && c2 <= 'F') ? (c2 - 'A' + 10)
                                          : -1;
    if (val1 == -1 || val2 == -1) {
        return -1;
    }
    return (val1 << 4) | val2;
}

static bool isHexString(const std::string& str) {
    if (str.length() < 12) {
        return false;
    }
    for (char c : str) {
        if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))) {
            return false;
        }
    }
    return true;
}

static bool isDecimalString(const std::string& str) {
    if (str.length() < 10) {
        return false;
    }
    for (char c : str) {
        if (!(c >= '0' && c <= '9')) {
            return false;
        }
    }
    return true;
}

static std::string decodeBcdSmsc(const std::string& pdu) {
    if (pdu.length() < 4) {
        return "";
    }

    int len = parseHexByte(pdu, 0);
    if (len < 0) {
        return "";
    }

    if (pdu.length() < static_cast<size_t>(2 + len * 2)) {
        return "";
    }

    int toa = parseHexByte(pdu, 2);
    if (toa < 0) {
        return "";
    }

    std::string num = "";
    for (size_t i = 4; i < static_cast<size_t>(2 + len * 2); i += 2) {
        if (i + 1 >= pdu.length()) {
            break;
        }
        char c1 = pdu[i + 1];
        char c2 = pdu[i];
        if (c1 != 'F' && c1 != 'f') {
            num += c1;
        }
        if (c2 != 'F' && c2 != 'f') {
            num += c2;
        }
    }

    if ((toa & 0xF0) == 0x90) {
        num = "+" + num;
    }
    return num;
}

static std::string fixSmscAddress(const std::string& origSmsc) {
    std::string smsc = origSmsc;

    if (smsc.find('"') != std::string::npos || smsc.find(',') != std::string::npos) {
        size_t firstQuote = smsc.find('"');
        if (firstQuote != std::string::npos) {
            size_t secondQuote = smsc.find('"', firstQuote + 1);
            if (secondQuote != std::string::npos) {
                smsc = smsc.substr(firstQuote + 1, secondQuote - firstQuote - 1);
            }
        }
    }

    if (isHexString(smsc) && smsc.rfind("07", 0) == 0) {
        std::string decoded = decodeBcdSmsc(smsc);
        if (!decoded.empty()) {
            smsc = decoded;
        }
    } else {
        if (isDecimalString(smsc) && smsc.rfind("+", 0) != 0) {
            smsc = "+" + smsc;
        }
    }

    return smsc;
}

static void shimOnRequest(int request, void* data, size_t datalen, RIL_Token token,
                          RIL_SOCKET_ID socketId) {
    {
        std::lock_guard<std::mutex> lock(gTokenMapMutex);
        gTokenRequestMap[token] = request;
    }

    gRealOnRequest(request, data, datalen, token, socketId);
}

static void shimOnRequestComplete(RIL_Token token, RIL_Errno error, void* response,
                                  size_t responselen) {
    int request = -1;
    {
        std::lock_guard<std::mutex> lock(gTokenMapMutex);
        auto it = gTokenRequestMap.find(token);
        if (it != gTokenRequestMap.end()) {
            request = it->second;
            gTokenRequestMap.erase(it);
        }
    }

    if (request == RIL_REQUEST_GET_SMSC_ADDRESS && error == RIL_E_SUCCESS && response != nullptr &&
        responselen > 0) {
        const char* originalSmsc = static_cast<const char*>(response);
        std::string fixedSmsc = fixSmscAddress(originalSmsc);

        ALOGI("sec-ril-shim: GET_SMSC_ADDRESS response: %s -> %s", originalSmsc, fixedSmsc.c_str());

        gRealEnv->OnRequestComplete(token, error, const_cast<char*>(fixedSmsc.c_str()),
                                    fixedSmsc.length() + 1);
        return;
    }

    gRealEnv->OnRequestComplete(token, error, response, responselen);
}

extern "C" const RIL_RadioFunctions* RIL_Init(const RIL_Env* env, int argc, char** argv) {
    RilInit realRilInit = getRealInit("RIL_Init");
    if (realRilInit == nullptr) {
        return nullptr;
    }

    gRealEnv = env;
    gShimEnv = *env;
    gShimEnv.OnRequestComplete = shimOnRequestComplete;

    const RIL_RadioFunctions* real = realRilInit(&gShimEnv, argc, argv);
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

    ALOGI("sec-ril-shim: installed SMSC format shim");
    return real;
}

extern "C" const RIL_RadioFunctions* RIL_SAP_Init(const RIL_Env* env, int argc, char** argv) {
    RilInit realSapInit = getRealInit("RIL_SAP_Init");
    if (realSapInit == nullptr) {
        return nullptr;
    }

    return realSapInit(env, argc, argv);
}
