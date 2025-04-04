#!/vendor/bin/sh

#########################################################
### init.insmod.cfg format:                           ###
### ------------------------------------------------  ###
### [insmod|setprop|enable/modprobe] [path|prop name] ###
### ...                                               ###
#########################################################

if [ $# -eq 1 ]; then
  cfg_file=$1
else
  # Set property even if there is no insmod config
  # to unblock early-boot trigger
  setprop vendor.common.modules.ready
  setprop vendor.device.modules.ready
  exit 1
fi

if [ "$cfg_file" == "system_dlkm" ]; then
  modules_dir=
  for f in /system/lib/modules/*/modules.dep /system/lib/modules/modules.dep /system_dlkm/lib/modules/*/modules.dep; do
    if [[ -f "$f" ]]; then
      modules_dir="$(dirname "$f")"
      break
    fi
  done
  if [[ -z "${modules_dir}" ]]; then
    echo "Unable to locate kernel modules directory" 2>&1
    exit 1
  fi
  echo "modules_dir is ${modules_dir}" 2>&1
  modprobe -a -d "${modules_dir}" --all=${modules_dir}/modules.load
elif [ -f $cfg_file ]; then
  while IFS="|" read -r action arg
  do
    case $action in
      "insmod") insmod $arg ;;
      "setprop") setprop $arg 1 ;;
      "enable") echo 1 > $arg ;;
      "modprobe") modprobe -a -d /vendor/lib/modules $arg ;;
    esac
  done < $cfg_file
fi
