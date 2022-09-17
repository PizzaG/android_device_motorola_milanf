#!/vendor/bin/sh
#
# Copyright (c) 2016, Motorola Mobility LLC,  All rights reserved.
#
# The purpose of this script is to annotate panic dumps with useful information
# about the context of the event.
#

export PATH=/vendor/bin:$PATH

annotate()
{
    VAL=`$2`
    [ "$VAL" ] || return
    if [ -e /sys/fs/pstore/annotate-ramoops-0 ] ; then
        echo "$1: $VAL" > /sys/fs/pstore/annotate-ramoops-0
    fi

    if [ -e /proc/driver/mmi_annotate ] ; then
        echo "$1: $VAL" > /proc/driver/mmi_annotate
    fi
}

case $1 in
    build*)
        annotate "Boot mode" "getprop ro.boot.mode"
        annotate "Console" "getprop ro.boot.console"
        annotate "Secure hardware" "getprop ro.boot.secure_hardware"
        annotate "Hab cid" "getprop ro.boot.hab.cid"
        annotate "VB state" "getprop ro.boot.verifiedbootstate"
        annotate "Verity mode" "getprop ro.boot.veritymode"
        ;;
esac
