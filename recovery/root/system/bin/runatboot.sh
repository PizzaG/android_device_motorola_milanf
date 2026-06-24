#!/system/bin/sh
#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP Device Tree Generator
# Copyright (C) 2019-Present A-Team Digital Solutions
# Copyright (C) 2024 sosRR
#

# Set SeLinux Permissions
setenforce 0

# Mount Partitions
mount /vendor

# Modprobe Device Drivers(Modules)
modprobe -d /vendor/lib/modules /vendor/lib/modules/nova_0flash_mmi.ko

# Rest
sleep 1

# Flash Csot Novatek Touch Firmware
if [ $(cat /sys/devices/platform/soc/5e00000.qcom,mdss_mdp/drm/card0/card0-DSI-1/panelSupplier) == "csot" ]
then
echo 1 > /sys/class/touchscreen/primary/forcereflash
echo csot_novatek_ts_fw.bin > /sys/class/touchscreen/primary/doreflash
echo "Reflashing Csot Firmware..."
echo 0 > /sys/class/touchscreen/primary/forcereflash

# Flash Tm Novatek Touch Firmware
elif [ $(cat /sys/devices/platform/soc/5e00000.qcom,mdss_mdp/drm/card0/card0-DSI-1/panelSupplier) == "tm" ]
then
echo 1 > /sys/class/touchscreen/primary/forcereflash
echo tm_novatek_ts_fw.bin > /sys/class/touchscreen/primary/doreflash
echo "Reflashing Tm Firmware..."
echo 0 > /sys/class/touchscreen/primary/forcereflash

# Unsupported Touchscreen
else
echo "Unsupported Touchscreen Detected"
fi   

# Qualcomm Modem + ADSP Firmware Loading
mkdir /firmware
SLOT=$(getprop ro.boot.slot_suffix)
mount /dev/block/bootdevice/by-name/modem$SLOT /firmware -O ro
echo "1" > /proc/sys/kernel/firmware_config/force_sysfs_fallback
echo "1" > /sys/kernel/boot_adsp/boot
exit 0