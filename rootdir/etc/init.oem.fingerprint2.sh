#!/vendor/bin/sh
script_name=${0##*/}
script_name=${script_name%.*}
function log {
        echo "$script_name: $*" > /dev/kmsg
}

persist_fps_id2=/mnt/vendor/persist/fps/last_vendor_id

fps_vendor=$(cat $persist_fps_id2)

rmmod fpc1020_mmi
rmmod fpsensor_spi_tee
sleep 0.5

setprop vendor.hw.fps.ident $fps_vendor
if [ $fps_vendor == "chipone" ]; then
        insmod /vendor/lib/modules/fpsensor_spi_tee.ko
        sleep 2
        start chipone_fp_hal
else
        insmod /vendor/lib/modules/fpc1020_mmi.ko
        sleep 2
        start fps_hal
fi

log "Done"
