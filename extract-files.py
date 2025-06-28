#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_vendorcompat,
    lib_fixups_user_type,
    libs_proto_3_9_1,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/samsung/s5e8535-common',
    'hardware/samsung',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    libs_proto_3_9_1: lib_fixup_vendorcompat,
    (
        'libuuid',
    ) : lib_fixup_vendor_suffix,
} # fmt: skip

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/init/android.hardware.security.keymint-service-samsung.rc': blob_fixup()
        .regex_replace('android.hardware.security.keymint-service', 'android.hardware.security.keymint-service.samsung'),
    'vendor/lib64/libwvaidl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libsamsungcamerahal.so': blob_fixup()
        .sig_replace('10 8A', 'C0 8A'),
    'vendor/lib64/libSecC2ComponentStore.so': blob_fixup()
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vendor.so'),
    'vendor/lib64/libcodec2_vendor.so': blob_fixup()
        .add_needed('libui_shim.so'),
    'vendor/etc/init/vendor.samsung.hardware.camera.provider-service_64.rc': blob_fixup()
        .regex_replace('media vendor_secdir', 'media')
        .regex_replace('vendor_secdir', 'camera'),
}  # fmt: skip

module = ExtractUtilsModule(
    's5e8535-common',
    'samsung',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
