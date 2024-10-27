#!/vendor/bin/sh
if ! applypatch --check EMMC:/dev/block/by-name/recovery$(getprop ro.boot.slot_suffix):100663296:cd6ca952ebe31a4eb1d3456b7660048cdf6aab20; then
  applypatch \
          --patch /vendor/recovery-from-boot.p \
          --source EMMC:/dev/block/by-name/boot$(getprop ro.boot.slot_suffix):67108864:82549e7de022271acce13ba99a4e783e5faa1dda \
          --target EMMC:/dev/block/by-name/recovery$(getprop ro.boot.slot_suffix):100663296:cd6ca952ebe31a4eb1d3456b7660048cdf6aab20 && \
      (log -t install_recovery "Installing new recovery image: succeeded" && setprop vendor.ota.recovery.status 200) || \
      (log -t install_recovery "Installing new recovery image: failed" && setprop vendor.ota.recovery.status 454)
else
  log -t install_recovery "Recovery image already installed" && setprop vendor.ota.recovery.status 200
fi

