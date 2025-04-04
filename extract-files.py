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
    'device/samsung/universal8535-common',
    'hardware/samsung',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    libs_proto_3_9_1: lib_fixup_vendorcompat,
    (
        'libuuid',
        'libsecril-client',
    ) : lib_fixup_vendor_suffix,
} # fmt: skip

blob_fixups: blob_fixups_user_type = {
    (
        'vendor/bin/hw/android.hardware.security.keymint-service.samsung',
        'vendor/lib64/libskeymint10device.so',
        'vendor/lib64/libskeymint_cli.so',
    ): blob_fixup()
        .add_needed('android.hardware.security.rkp-V3-ndk.so')
        .replace_needed('libcrypto.so', 'libcrypto-v33.so')
        .replace_needed('libcppbor_external.so', 'libcppbor.so'),
    'vendor/etc/init/android.hardware.security.keymint-service.rc': blob_fixup()
        .regex_replace('android.hardware.security.keymint-service', 'android.hardware.security.keymint-service.samsung'),
    'vendor/lib64/libwvaidl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libsec-ril.so': blob_fixup()
        .binary_regex_replace(b'ril.dds.call.ongoing', b'vendor.calls.slot_id'),
   (
       'vendor/lib/libexynosgraphicbuffer.so',
       'vendor/lib64/libexynosgraphicbuffer.so',
   ): blob_fixup()
        .replace_needed('libui.so', 'libui_shim.so'),
   (
       'vendor/lib64/libaboxpcmdump.so',
       'vendor/lib/libaboxpcmdump.so',
       'vendor/lib64/libaudioparamupdate.so',
       'vendor/lib/libaudioparamupdate.so',
   ): blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute_vendor.so'),
    'vendor/lib64/unihal_android.so': blob_fixup()
        .add_needed('libshim_sensorndkbridge.so')
        .add_needed('libui_shim.so'),
    'vendor/lib64/libsensorlistener.so': blob_fixup()
        .add_needed('libshim_sensorndkbridge.so'),
    'vendor/lib64/hw/camera.s5e8535.so': blob_fixup()
        .add_needed('libui_shim.so'),
   (
       'vendor/lib/libaudioproxy2.so',
       'vendor/lib64/libaudioproxy2.so',
   ): blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute_vendor.so')
        .replace_needed('libtinyalsa.so', 'libtinyalsa_vendor.so'),
   (
       'vendor/lib64/hw/audio.primary.s5e8535.so',
       'vendor/lib/hw/audio.primary.s5e8535.so',
   ): blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute_vendor.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'universal8535-common',
    'samsung',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
