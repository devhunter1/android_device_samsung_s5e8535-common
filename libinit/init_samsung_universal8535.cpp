/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_variant.h>
#include <libinit_utils.h>
#include <unistd.h>

#include "vendor_init.h"

static const variant_info_t m14x_info = {
    .hwc_value = "",
    .sku_value = "m14x",

    .brand = "Samsung",
    .device = "m14x",
    .marketname = "Samsung Galaxy M14",
    .model = "SM-M146X",
    .build_fingerprint = "samsung/m14xins/essi:14/UP1A.231005.007/E146BXXS5CXH1:user/release-keys"
};

static const variant_info_t a14x_info = {
    .hwc_value = "",
    .sku_value = "a14x",

    .brand = "Samsung",
    .device = "a14x",
    .marketname = "Samsung Galaxy A14",
    .model = "SM-A146X",
    .build_fingerprint = "samsung/a14xins/essi:14/UP1A.231005.007/A146BXXS5CXH1:user/release-keys"
};


static const std::vector<variant_info_t> variants = {
    m14x_info,
    a14x_info,
};

void vendor_load_properties() {
    if (access("/system/bin/recovery", F_OK) != 0) {
        search_variant(variants);
    }
}
