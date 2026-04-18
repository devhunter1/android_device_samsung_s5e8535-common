#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_vendorcompat,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/samsung/s5e8535-common',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    (
        'libuuid',
        'libsecril-client',
    ) : lib_fixup_vendor_suffix,
} # fmt: skip

blob_fixups: blob_fixups_user_type = {
   (
       'vendor/lib64/libaboxpcmdump.so',
       'vendor/lib/libaboxpcmdump.so',
       'vendor/lib64/libaudioparamupdate.so',
       'vendor/lib/libaudioparamupdate.so',
   ): blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute_vendor.so'),
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
   'vendor/etc/init/android.hardware.security.keymint-service.samsung.rc': blob_fixup()
        .regex_replace('android.hardware.security.keymint-service', 'android.hardware.security.keymint-service.samsung'),
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
