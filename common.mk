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


# API levels
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := true

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl_universal8535 \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl \
    audio.bluetooth.default \
    audio.primary.default \
    audio.r_submix.default \
    audio.sec_primary.default \
    audio.usb.default \
    libaudioroute \
    libtinyalsa \
    libtinycompress \
    libaudiofoundation.vendor \
    android.hardware.soundtrigger@2.0-impl \
    audio.sec_primary.default
    
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
    
PRODUCT_COPY_FILES += \
    hardware/samsung_slsi/libbt/conf/bt_did.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_did.conf
    
# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.dual_role_usb
    
# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.samsung
    
    
# Camera
TARGET_BUILD_APERTURE_CAMERA := true

PRODUCT_PACKAGES += \
    android.hardware.camera.provider-service.samsung

    
# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service
    
# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.2.vendor:64
    
PRODUCT_PACKAGES += \
    sehradiomanager \
    secril_config_svc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ril/sehradiomanager.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sehradiomanager.conf
    
# Sensor
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service.multihal

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf
    

# DOZE
PRODUCT_PACKAGES += \
    SamsungDoze
    
# Security
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-service
    
# VIB
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.samsung
    
# Biometrics face
PRODUCT_PACKAGES += \
    android.hardware.biometrics.face-service.example
    
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.biometrics.face.xml
    
# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.samsung-mali

# Boot animation
TARGET_SCREEN_HEIGHT := 2408 
TARGET_SCREEN_WIDTH := 1080

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager 

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
    android.hardware.graphics.composer@2.4-service \
    libdrm.vendor:64
    
# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0.vendor
   
# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr
    
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json


# Permission
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    $(COMMON_PATH)/configs/permissions/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
     $(COMMON_PATH)/configs/permissions/android.hardware.vulkan.compute.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
     $(COMMON_PATH)/configs/permissions/android.hardware.vulkan.level.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
     $(COMMON_PATH)/configs/permissions/android.hardware.vulkan.version.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
     $(COMMON_PATH)/configs/permissions/android.software.opengles.deqp.level.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
     $(COMMON_PATH)/configs/permissions/android.software.vulkan.deqp.level.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
     $(COMMON_PATH)/configs/permissions/vendor.samsung.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/vendor.samsung.hardware.telephony.gsm.xml
    
    
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
    
# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.samsung \
    android.hardware.health-service.samsung-recovery
    
# Keymaster
PRODUCT_PACKAGES += \
    libkeymaster4_1support.vendor:64

# Overlays
PRODUCT_PACKAGES += \
    SystemUIOverlay_universal8535 \
    FrameworksResOverlay_universal8535 \
    WifiOverlay
    
DEVICE_PACKAGE_OVERLAYS += \
    $(COMMON_PATH)/overlay-lineage \
    $(COMMON_PATH)/overlay

PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

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
    $(COMMON_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_RAMDISK)/fstab.s5e8535 \
    $(COMMON_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.s5e8535 \
    $(COMMON_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.s5e8535 \
    $(COMMON_PATH)/configs/init/init.recovery.s5e8535.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.s5e8535.rc \
    $(COMMON_PATH)/configs/init/init.recovery.samsung.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.samsung.rc \
    $(COMMON_PATH)/rootdir/etc/init.insmod.s5e8535.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.s5e8535.cfg \
    $(COMMON_PATH)/rootdir/etc/fstab.s5e8535:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.s5e8535 \
    $(COMMON_PATH)/rootdir/etc/fstab.ramplus:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.ramplus \
    $(COMMON_PATH)/rootdir/etc/init.ramplus.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.ramplus.rc \
    $(COMMON_PATH)/rootdir/etc/init.s5e8535.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.s5e8535.rc \
    $(COMMON_PATH)/rootdir/etc/init.s5e8535.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.s5e8535.usb.rc

	
# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 33

# OMX
PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-service \
    libepicoperator
    
# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.common-V2-ndk.vendor \
    android.hardware.biometrics.fingerprint-V2-ndk.vendor

PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.samsung

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml
    
# WIFI
PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    hostapd_cli \
    wpa_cli \
    libwifi-hal \
    libkeystore-wifi-hidl \
    android.hardware.wifi-service \
    libkeystore-engine-wifi-hidl \
    android.system.keystore2-V1-ndk
    
    
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(COMMON_PATH)/configs/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(COMMON_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf
    
PRODUCT_CFI_INCLUDE_PATHS += hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    hardware/google/interfaces \
    hardware/google/pixel \
    $(COMMON_PATH) \
    hardware/samsung \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/lineage/interfaces
    
PRODUCT_SOONG_NAMESPACES += \
    hardware/samsung_slsi-linaro/graphics \
    hardware/samsung_slsi-linaro/interfaces \
    hardware/samsung_slsi-linaro/openmax
    
# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat
	
# VNDK API
PRODUCT_TARGET_VNDK_VERSION := 33
PRODUCT_EXTRA_VNDK_VERSIONS := 33
	

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/universal8535-common/universal8535-common-vendor.mk)

# Inherit the sign keys
#$(call inherit-product, vendor/lineage-priv/keys/keys.mk)
