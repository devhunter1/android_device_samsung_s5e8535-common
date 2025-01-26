#!/bin/bash

options="-r vendor.samsung_slsi.hardware:vendor/samsung_slsi/hardware \
         -r android.hidl:system/libhidl/transport \
         -r android.hardware:hardware/interfaces"

outputs="vendor/samsung_slsi/hardware/epic/1.0/default"

# Generate Android.bp for .hal files
#hidl-gen -Landroidbp $options vendor.samsung_slsi.hardware.epic@1.0;

# Generate Header files for .hal files
#hidl-gen -L c++-headers -o $outputs $options vendor.samsung_slsi.hardware.epic@1.0;

# Generate CPP files for .hal files
#hidl-gen -L c++-impl -o $outputs $options vendor.samsung_slsi.hardware.epic@1.0;

# Generate Android.bp for Default IMPL
#hidl-gen -L androidbp-impl -o $outputs $options vendor.samsung_slsi.hardware.epic@1.0;

hidl-gen -Lhash $options vendor.samsung_slsi.hardware.epic@1.0
