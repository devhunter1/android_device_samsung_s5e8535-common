$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel) $(RECOVERYIMAGE_EXTRA_DEPS) $(AVBTOOL)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(hide) $(AVBTOOL) add_hash_footer --image $@ --partition_size $(BOARD_RECOVERYIMAGE_PARTITION_SIZE) --partition_name recovery --algorithm $(BOARD_AVB_RECOVERY_ALGORITHM) --key $(BOARD_AVB_RECOVERY_KEY_PATH)
	@echo "Made recovery image: $@"
