#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter $(TARGET_DEVICE),a14x m14x),)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif