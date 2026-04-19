#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/s5e8535-common

# Updatable APEX
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Non A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/s5e8535-common/s5e8535-common-vendor.mk)

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl \
    audio.bluetooth.default \
    android.hardware.bluetooth.audio-impl \
    audio.usb.default \
    audio.r_submix.default

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(COMMON_PATH)/configs/audio/audio_board_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_board_info.xml \
    $(COMMON_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(COMMON_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    $(COMMON_PATH)/configs/audio/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml

TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_PACKAGES += \
    SamsungDAP

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service \
    libbt-vendor:64

PRODUCT_COPY_FILES += \
    hardware/samsung_slsi/libbt/conf/bt_did.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_did.conf \
    hardware/samsung_slsi/libbt/conf/bt_vendor.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Charger
PRODUCT_PACKAGES += \
    charger_res_images_vendor

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 450dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.samsung

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl:64 \
    android.hardware.gatekeeper@1.0-service

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.samsung \
    android.hardware.health-service.samsung-recovery

# init	
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/fstab.s5e8535:$(TARGET_COPY_OUT_RAMDISK)/fstab.s5e8535 \
    $(COMMON_PATH)/configs/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.s5e8535 \
    $(COMMON_PATH)/configs/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.s5e8535 \
    $(COMMON_PATH)/configs/init/init.recovery.s5e8535.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.s5e8535.rc \
    $(COMMON_PATH)/configs/init/init.recovery.samsung.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.samsung.rc \
    $(COMMON_PATH)/configs/init/init.insmod.s5e8535.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.s5e8535.cfg \
    $(COMMON_PATH)/configs/init/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.s5e8535 \
    $(COMMON_PATH)/configs/init/fstab.ramplus:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.ramplus \
    $(COMMON_PATH)/configs/init/init.ramplus.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.ramplus.rc \
    $(COMMON_PATH)/configs/init/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(COMMON_PATH)/configs/init/init.s5e8535.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.s5e8535.rc \
    $(COMMON_PATH)/configs/init/init.s5e8535.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.s5e8535.usb.rc

# Light
PRODUCT_PACKAGES += \
    android.hardware.light-service.samsung

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.samsung-mali

# Product characteristics
PRODUCT_CHARACTERISTICS := phone

# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat

# RIL
PRODUCT_PACKAGES += \
    sehradiomanager \
    secril_config_svc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ril/sehradiomanager.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sehradiomanager.conf

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.samsung-multihal

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Shipping API level
BOARD_SHIPPING_API_LEVEL := 33
PRODUCT_SHIPPING_API_LEVEL := $(BOARD_SHIPPING_API_LEVEL)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    hardware/samsung \
    hardware/samsung_slsi/libbt \
    hardware/samsung_slsi/scsc_wifibt/wifi_hal \
    hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.samsung \
    android.hardware.usb.gadget-service.samsung

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.samsung

# WIFI
PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    hostapd_cli \
    wpa_cli \
    android.hardware.wifi-service

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(COMMON_PATH)/configs/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(COMMON_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \

PRODUCT_CFI_INCLUDE_PATHS += hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib
