/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string>
#include <vector>

struct HyPerToken {
};

void hyper_acquire(HyPerToken, int, std::vector<int, std::allocator<int> >) {
}

void hyper_getNewHyPerToken(void) {
}

void hyper_setTokenProcName(HyPerToken*, std::string) {
}

void hyper_checkResourceExist(int) {
}

void hyper_release(HyPerToken) {
}

void hyper_checkHintExist(int) {
}

void hyper_init(void) {
}
