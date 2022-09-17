#!/vendor/bin/sh
#
# Start indicated fingerprint HAL service
#
# Copyright (c) 2019 Lenovo
# All rights reserved.
#
# April 15, 2019  chengql2@lenovo.com  Initial version
# December 2, 2019  chengql2  Store fps_id into persist fs
# November 19, 2020 zengzm refactor the code, support more than 3 fingerprint sensors; support config.

# get the filename, contains the file postfix
script_name=${0##*/}
# remove the file postfix
script_name=${script_name%.*}
function log {
    echo "$script_name: $*" > /dev/kmsg
}

PROP_GKI_PATH=ro.vendor.mot.gki.path
GKI_PATH=$(getprop $PROP_GKI_PATH)

# for new projects, only need to config varible vendor_list,kernel_so_list,kernel_so_name_list,hal_list
# vendor_list: the array contains the sensor name, it will be used for system properties.
# kernel_so_list: the array contains the kernel so's absolute path. It will be used at insmod.
# kernel_so_name_list: the array contains the kernel so's name. It will be used at rmmod.
# hal_list: the array contains the hal service name.
#
# note: all arrays should have the same size.
vendor_list=('egis' 'silead')
kernel_so_list=("/vendor/lib/modules/$GKI_PATH/rbs_fps_mmi.ko" "/vendor/lib/modules/$GKI_PATH/silead_fps_mmi.ko")
kernel_so_name_list=("rbs_fps_mmi.ko" "silead_fps_mmi.ko")
hal_list=('ets_hal' 'silead_hal')
last_vendor_index=`expr ${#vendor_list[@]} - 1`
vendor_list_size=${#vendor_list[@]}

if [ $vendor_list_size != ${#kernel_so_list[@]} ]; then
    log "error, vendor_list.size is not equal to kernel_so_list"
    return 255
fi

if [ $vendor_list_size != ${#kernel_so_name_list[@]} ]; then
    log "error, vendor_list.size is not equal to kernel_so_name_list"
    return 255
fi

if [ $vendor_list_size != ${#hal_list[@]} ]; then
    log "error, vendor_list.size is not equal to hal_list"
    return 255
fi

# At the current boot, what is the fingerprint sensor
persist_fps_id=/mnt/vendor/persist/fps/vendor_id

# what is the fingerprint sensor successfully installed before.
persist_fps_id2=/mnt/vendor/persist/fps/last_vendor_id

FPS_VENDOR_NONE=none
MAX_TIMES=20

# this property store FPS_STATUS_NONE or FPS_STATUS_OK
# after start fingerprint hal service, the hal service will set this property.
prop_fps_status=vendor.hw.fingerprint.status

# use this to trigger init.mmi.rc
prop_fps_ident=vendor.hw.fps.ident

# if $prop_fps_status=$FPS_STATUS_OK, then will set prop_persist_fps to the specific vendor name.
prop_persist_fps=persist.vendor.hardware.fingerprint

FPS_STATUS_NONE=none
FPS_STATUS_OK=ok

function find_vendor_index() {
    # param1: the specific vendor name
    # return: the vendor index in vendor_list. the valid index is from 0; if not found,return 255
    for temp_vendor_index in $(seq 0 $last_vendor_index)
    do
        if [ "${vendor_list[temp_vendor_index]}" = "$1" ]; then
            return $temp_vendor_index
        fi
    done
    return 255
}

function start_hal_service(){
    # param1: the vendor index
    # return: 0 means success, will setprop $prop_persist_fps
    setprop $prop_fps_status $FPS_STATUS_NONE
    setprop $prop_fps_ident $FPS_STATUS_NONE

    insmod ${kernel_so_list[$1]}
    log "${kernel_so_list[$1]} insmod"
    sleep 1
    setprop $prop_fps_ident ${vendor_list[$1]}

    log "start ${hal_list[$1]}"
    start ${hal_list[$1]}

    for ii in $(seq 1 $MAX_TIMES)
    do
        sleep 0.1
        fps_status=$(getprop $prop_fps_status)
        # log "check fps vendor status: $fps_status"
        if [ $fps_status != $FPS_STATUS_NONE ]; then
            break
        fi
    done

    log "fingerprint HAL status: $fps_status"
    if [ $fps_status == $FPS_STATUS_OK ]; then
        log "start ${hal_list[$1]} hal success"
        setprop $prop_persist_fps ${vendor_list[$1]}
        return 0
    fi

    log "start ${hal_list[$1]} hal failed, remove kernel so: ${kernel_so_name_list[$1]} "
    setprop ctl.stop ${hal_list[$1]}
    rmmod ${kernel_so_name_list[$1]}
    sleep 0.1
    # if failed,return 255
    return 255
}

# set last fingerprint sensor
fps_vendor=$(cat $persist_fps_id)
if [ -n "$fps_vendor" ] && [ "$fps_vendor" != $FPS_STATUS_NONE ]; then
    echo $fps_vendor > $persist_fps_id2
fi

# get the identified fingerprint sensor
fps_vendor2=$(cat $persist_fps_id2)
if [ -z $fps_vendor2 ]; then
    fps_vendor2=$FPS_VENDOR_NONE
fi
log "FPS vendor (last): $fps_vendor2"

fps_vendor=$(cat $persist_fps_id)
if [ -z $fps_vendor ]; then
    fps_vendor=$FPS_VENDOR_NONE
fi
log "FPS vendor (current): $fps_vendor"

vendor_index=255
# try to start the most recent success launched sensor.
if [ $fps_vendor != $FPS_STATUS_NONE ]; then
    find_vendor_index $fps_vendor
    vendor_index=$?
    if [ $vendor_index != 255 ]; then
        log "start $fps_vendor hal service"
        start_hal_service $vendor_index
        if [ $? != 255 ]; then
            return 0
        fi
    fi
fi

# try all the fingerprint sensors
for temp_vendor_index in $(seq 0 $last_vendor_index)
do
    if [ $temp_vendor_index == $vendor_index ]; then
        continue
    fi

    if [ ! -e ${kernel_so_list[$temp_vendor_index]} ]; then
        log "does not exist ${kernel_so_list[$temp_vendor_index]},ignore this fingerprint sensor"
        continue
    fi

    start_hal_service $temp_vendor_index
    if [ $? != 255 ]; then
        echo ${vendor_list[$temp_vendor_index]} > $persist_fps_id
        return 0
    fi
done

log "error, no fingerprint sensor found"
setprop $prop_persist_fps $FPS_VENDOR_NONE
echo $FPS_VENDOR_NONE > $persist_fps_id
