#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/universal8535-common

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Generic Ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Soong namespaces
$(call inherit-product, hardware/samsung_slsi-linaro/config/config.mk)

# API levels
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl \
    audio.bluetooth.default \
    audio.primary.default \
    audio.r_submix.default \
    audio.sec_primary.default \
    audio.usb.default \
    libaudioroute \
    libtinyalsa \
    libtinycompress
    
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/audio/configs/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(COMMON_PATH)/audio/configs/audio_board_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_board_info.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dpsink_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml  

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.a2dp@1.0-impl-exynos \
    android.hardware.bluetooth@1.1-impl \
    android.hardware.bluetooth@1.1-service \
    libbt-vendor:64
    
    
# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.samsung
    

PRODUCT_COPY_FILES += \
    hardware/samsung_slsi/libbt/conf/bt_did.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_did.conf \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml
    
# Camera
TARGET_BUILD_APERTURE_CAMERA := true

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.5-service_64.exynos1330 \
    libsensorndkbridge
    

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.ar.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml
    
# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

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
    
# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service
    
# RenderScript
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport \
    libhardware \
    libhwbinder

#LPM
PRODUCT_PACKAGES += \
    system_ext_33.0.cil
    
# FastCharge
PRODUCT_PACKAGES += \
    vendor.lineage.fastcharge@1.0-service.samsung
    
# Epic
PRODUCT_PACKAGES += \
    vendor.samsung_slsi.hardware.epic@1.0-impl \
    libepicoperator \
    vendor.samsung_slsi.hardware.epic@1.0-service
    
# GNSS
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor:64 \
    android.hardware.gnss@2.1.vendor:64
    
# Keymaster
PRODUCT_PACKAGES += \
    libkeymaster4_1support.vendor:64

# Overlays
PRODUCT_PACKAGES += \
    SystemUIOverlay_universal8535 \
    FrameworksResOverlay_universal8535
    
DEVICE_PACKAGE_OVERLAYS += \
    $(COMMON_PATH)/overlay-lineage \
    $(COMMON_PATH)/overlay

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
    $(LOCAL_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.s5e8535 \
    $(LOCAL_PATH)/configs/init/init.recovery.s5e8535.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.s5e8535.rc \
    $(LOCAL_PATH)/configs/init/init.recovery.samsung.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.samsung.rc 

	
# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33


# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    hardware/google/interfaces \
    hardware/google/pixel \
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
