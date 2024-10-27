#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/universal8535-common

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# API levels
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Bluetooth
PRODUCT_PACKAGES += \
    audio.sysbta.default \
    android.hardware.bluetooth.audio-service-system

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/bluetooth/audio/config/sysbta_audio_policy_configuration.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysbta_audio_policy_configuration.xml \
    $(COMMON_PATH)/bluetooth/audio/config/sysbta_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysbta_audio_policy_configuration_7_0.xml

# Boot animation
TARGET_SCREEN_HEIGHT := 2408 
TARGET_SCREEN_WIDTH := 1080 

# Charger
PRODUCT_PACKAGES += \
    charger_res_images_vendor \
    libsuspends

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport \
    libhardware \
    libhwbinder

#LPM
PRODUCT_PACKAGES += \
    system_ext_33.0.cil

# Overlays
PRODUCT_PACKAGES += \
    SystemUIOverlay_universal8535
    
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Product characteristics
PRODUCT_CHARACTERISTICS := phone

# Rootdir
PRODUCT_PACKAGES += \
    scsc_get_platform_info.sh \
    mx_logger_dump.sh \
    init.insmod.sh \
    gps.sh \
    enable_test_mode.sh \
    mx_log_collection.sh \
    install-recovery.sh 
	
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_RAMDISK)/fstab.s5e8535 \
    $(LOCAL_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.s5e8535 \
    $(LOCAL_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.s5e8825 \
    $(LOCAL_PATH)/configs/init/init.recovery.s5e8535.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.s5e8535.rc \
    $(LOCAL_PATH)/configs/init/init.recovery.samsung.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.samsung.rc 

	
# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(COMMON_PATH) \
    hardware/samsung 
	
# VNDK API
PRODUCT_TARGET_VNDK_VERSION := 33
PRODUCT_EXTRA_VNDK_VERSIONS := 33

# Vendor_overlays
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/vendor_overlay/,$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/33/)
	

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/universal8535/universal8535-vendor.mk)

# Inherit the sign keys
#$(call inherit-product, vendor/lineage-priv/keys/keys.mk)

