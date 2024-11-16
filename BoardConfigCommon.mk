#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/universal8535-common

BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true
ALLOW_MISSING_DEPENDENCIES=true

## Board
BOARD_VENDOR := samsung
TARGET_BOOTLOADER_BOARD_NAME := s5e8535
TARGET_BOARD_PLATFORM := universal8535
TARGET_SOC := s5e8535
TARGET_NO_BOOTLOADER := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_USES_64_BIT_BINDER := true


# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

#Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth/include

# Boot
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_CUSTOM_BOOTIMG := true
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_CMDLINE := bootconfig buildtime_bootconfig=enable loop.max_part=7 androidboot.init_fatal_reboot_target=recovery
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x00000000
BOARD_KERNEL_SECOND_OFFSET := 0xf0000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000000
BOARD_DTB_OFFSET := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) 
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) --second_offset $(BOARD_KERNEL_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION) --pagesize $(BOARD_KERNEL_PAGESIZE) --board $(BOARD_NAME)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# Display
TARGET_SCREEN_DENSITY := 450

# DTBO
BOARD_KERNEL_SEPARATED_DTBO := true

# Init
TARGET_INIT_VENDOR_LIB := //$(COMMON_PATH):init_samsung_universal8535
TARGET_RECOVERY_DEVICE_MODULES := init_samsung_universal8535

# Init Boot
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

# Kernel
BOARD_RAMDISK_USE_LZ4 := true

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_LLVM_BINUTILS := false
TARGET_KERNEL_VERSION := 5.15
TARGET_KERNEL_ADDITIONAL_FLAGS += \
	LLVM=1 LLVM_IAS=1 \
	TARGET_SOC=s5e8535 \
	ANDROID_MAJOR_VERSION=t \
	PLATFORM_VERSION=13 \
	DEPMOD=depmod \
	DTC_FLAGS="-@"

TARGET_KERNEL_CLANG_VERSION := r450784e

BOARD_INCLUDE_RECOVERY_DTBO := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 16777216
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_DTBOIMG_PARTITION_SIZE := 8388608        
BOARD_SUPER_PARTITION_SIZE := 8287944704
BOARD_USES_METADATA_PARTITION := true
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200

# Dynamic Partitions
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 8283750400
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product odm vendor_dlkm
-include vendor/lineage/config/BoardConfigReservedSize.mk
 
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor

BOARD_BUILD_VENDORIMAGE := false
BUILD_WITHOUT_VENDOR := true

# Platform
TARGET_BOARD_PLATFORM := universal8535

# Properties
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
TARGET_PRODUCT_PROP += $(COMMON_PATH)/product.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.s5e8535
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_HAS_DOWNLOAD_MODE := true
BOARD_USES_FULL_RECOVERY_IMAGE := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2024-07-01

# SELinux
include device/lineage/sepolicy/exynos/sepolicy.mk
include device/samsung_slsi/sepolicy/sepolicy.mk
SELINUX_IGNORE_NEVERALLOWS := true
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/private
TARGET_USES_PREBUILT_VENDOR_SEPOLICY := true
TARGET_HAS_FUSEBLK_SEPOLICY_ON_VENDOR := true

# Vendor_boot
BOARD_VENDOR_RAMDISK_FRAGMENTS := dlkm
BOARD_VENDOR_RAMDISK_FRAGMENT.dlkm.KERNEL_MODULE_DIRS := top

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_SYSTEM := product system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 1
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# VNDK
BOARD_VNDK_VERSION := 33

## Wi-Fi
BOARD_WLAN_DEVICE                := slsi
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_slsi
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_slsi
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X



