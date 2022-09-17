#!/vendor/bin/sh

PATH=/sbin:/vendor/sbin:/vendor/bin:/vendor/xbin
export PATH

scriptname=${0##*/}

debug()
{
	echo "$*"
}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

get_history_value()
{
	local __result=$1
	local history_count=0
	local value=""
	local IFS=','

	shift 1
	for arg in ${@}; do
		value=$value",$arg"
		history_count=$(($history_count + 1))
		if [ $history_count -eq 3 ]; then
			break
		fi
	done
	eval $__result="$value"
	debug "value:$value history_count:$history_count"
}

set_reboot_bootseq_history()
{
	#get current boot sequence
	if [ ! -f /proc/bootinfo ]; then
		notice "Error:/proc/bootinfo is not ready"
		return
	fi
	boot_seq_line=`grep BOOT_SEQ /proc/bootinfo | sed 's/ //g'`
	boot_seq=${boot_seq_line##*:}
	notice "BOOT_SEQ is $boot_seq"
	shutdown_time=`date +%s`

	#get previous value of bootseq history
	bootseq_history=`getprop persist.vendor.reboot.bootseq.history`
	notice "booseq_history is $bootseq_history"
	get_history_value valid_history_value $bootseq_history
	setprop persist.vendor.reboot.bootseq.history "$boot_seq.$shutdown_time$valid_history_value"
	new_bootseq_history=`getprop persist.vendor.reboot.bootseq.history`
	notice "set persist.vendor.reboot.bootseq.history $new_bootseq_history"
}

set_reboot_bootseq_history
