# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
LOCAL_PATH := $(call my-dir)

PATCH_AVB  := $(COMMON_PATH)/modavb.py

MKDTIMG    := $(HOST_OUT_EXECUTABLES)/mkdtimg$(HOST_EXECUTABLE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
DTB_DIR    := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/exynos
DTB_CFG    := $(COMMON_PATH)/configs/kernel/$(TARGET_BOOTLOADER_BOARD_NAME).cfg
INSTALLED_DTBIMAGE_TARGET := $(PRODUCT_OUT)/dtb.img

define build-dtbimage-target
	@echo "Building dtb.img"
	$(MKDTIMG) cfg_create $@ $(DTB_CFG) -d $(DTB_DIR)
endef

$(INSTALLED_DTBIMAGE_TARGET): $(INSTALLED_KERNEL_TARGET) $(MKDTIMG)
	$(build-dtbimage-target)
.PHONY: dtbimage
dtbimage: $(INSTALLED_DTBIMAGE_TARGET)


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(AVBTOOL) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS) $(BOARD_AVB_BOOT_KEY_PATH)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	$(hide) $(AVBTOOL) add_hash_footer --image $@ --partition_size $(BOARD_BOOTIMAGE_PARTITION_SIZE) --partition_name boot --algorithm $(BOARD_AVB_RECOVERY_ALGORITHM) --key $(BOARD_AVB_RECOVERY_KEY_PATH)
	@echo "Made boot image: $@"


$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(AVBTOOL) $(recovery_ramdisk) $(recovery_kernel) $(RECOVERYIMAGE_EXTRA_DEPS) $(INSTALLED_DTBIMAGE_TARGET) $(BOARD_AVB_BOOT_KEY_PATH) $(BOARD_PREBUILT_DTBOIMAGE)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_RECOVERY_MKBOOTIMG_ARGS) --dtb $(INSTALLED_DTBIMAGE_TARGET) --output $@
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(hide) $(AVBTOOL) add_hash_footer --image $@ --partition_size $(BOARD_RECOVERYIMAGE_PARTITION_SIZE) --partition_name recovery --algorithm $(BOARD_AVB_RECOVERY_ALGORITHM) --key $(BOARD_AVB_RECOVERY_KEY_PATH)
	$(hide) python3 $(PATCH_AVB) --img $(PRODUCT_OUT)/recovery.img
	@echo "Made recovery image: $@"
