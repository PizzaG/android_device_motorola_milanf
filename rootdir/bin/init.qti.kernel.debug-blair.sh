#=============================================================================
# Copyright (c) 2021, Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2014-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

enable_tracing_events()
{
    # timer
    echo 1 > /sys/kernel/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/tracing/events/timer/timer_expire_exit/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_expire_exit/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_init/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/tracing/events/irq/enable
    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/tracing/events/workqueue/enable
    # schedular
    echo 1 > /sys/kernel/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_isolate/enable

    # video
    echo 1 > /sys/kernel/tracing/events/msm_vidc_events/enable
    # clock
    echo 1 > /sys/kernel/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/tracing/events/power/clock_disable/enable
    echo 1 > /sys/kernel/tracing/events/power/cpu_frequency/enable
    # regulator
    echo 1 > /sys/kernel/tracing/events/regulator/enable
    # power
    echo 1 > /sys/kernel/tracing/events/msm_low_power/enable

    #rmph_send_msg
    echo 1 > /sys/kernel/tracing/events/rpmh/rpmh_send_msg/enable

    #enable aop with timestamps

    #memory pressure events/oom
    echo 1 > /sys/kernel/tracing/events/psi/psi_event/enable
    echo 1 > /sys/kernel/tracing/events/psi/psi_window_vmstat/enable

    #Enable irqsoff/preempt tracing
    echo 1 > /sys/kernel/tracing/events/preemptirq_long/enable
    echo stacktrace > /d/tracing/events/preemptirq_long/preempt_disable_long/trigger
    echo stacktrace > /d/tracing/events/preemptirq_long/irq_disable_long/trigger

    echo 1 > /sys/kernel/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    setprop shlog_debug 1

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    enable_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable__tracing_events
}

enable_stm_hw_events()
{
   #TODO: Add HW events
}

config_dcc_core_hang()
{
    echo 0xF80005C > $DCC_PATH/config
    echo 0xF81005C > $DCC_PATH/config
    echo 0xF82005C > $DCC_PATH/config
    echo 0xF83005C > $DCC_PATH/config
    echo 0xF84005C > $DCC_PATH/config
    echo 0xF85005C > $DCC_PATH/config
    echo 0xF86005C > $DCC_PATH/config
    echo 0xF87005C > $DCC_PATH/config
    echo 0xF40003C > $DCC_PATH/config
}

config_dcc_pcu()
{
    #APPS PCU Register
    echo 0xF800040 > $DCC_PATH/config
    echo 0xF80004c > $DCC_PATH/config
    echo 0xF800024 > $DCC_PATH/config
    echo 0xF810024 > $DCC_PATH/config
    echo 0xF810040 > $DCC_PATH/config
    echo 0xF81004C > $DCC_PATH/config
    echo 0xF820024 > $DCC_PATH/config
    echo 0xF820040 > $DCC_PATH/config
    echo 0xF82004C > $DCC_PATH/config
    echo 0xF830024 > $DCC_PATH/config
    echo 0xF830040 > $DCC_PATH/config
    echo 0xF83004C > $DCC_PATH/config
    echo 0xF840024 > $DCC_PATH/config
    echo 0xF840040 > $DCC_PATH/config
    echo 0xF84004C > $DCC_PATH/config
    echo 0xF850024 > $DCC_PATH/config
    echo 0xF850040 > $DCC_PATH/config
    echo 0xF85004C > $DCC_PATH/config
    echo 0xF860024 > $DCC_PATH/config
    echo 0xF860040 > $DCC_PATH/config
    echo 0xF86004C > $DCC_PATH/config
    echo 0xF870024 > $DCC_PATH/config
    echo 0xF870040 > $DCC_PATH/config
    echo 0xF87004C > $DCC_PATH/config
    echo 0xF880024 > $DCC_PATH/config
    echo 0xF880040 > $DCC_PATH/config
    echo 0xF8801B4 3 > $DCC_PATH/config
    echo 0xF880200 > $DCC_PATH/config
    echo 0xFA80000 2 > $DCC_PATH/config
    echo 0xFA82000 2 > $DCC_PATH/config
    echo 0xFA84000 2 > $DCC_PATH/config

    #APPS FSM register
    echo 0xF880044 3 > $DCC_PATH/config
    echo 0xF880054 > $DCC_PATH/config
    echo 0xF88006C 5 > $DCC_PATH/config

    #APSS_APM_STATUS
    echo 0xFB00000 > $DCC_PATH/config
}

config_dcc_pimem()
{
    echo 0x1B60100 11 > $DCC_PATH/config
}

config_dcc_cpr()
{
    #CPR register
    echo 0xFBA0C50 > $DCC_PATH/config
    echo 0xFBA1090 > $DCC_PATH/config
    echo 0xFB90008 > $DCC_PATH/config
    echo 0xFB90020 2 > $DCC_PATH/config
    echo 0xFB90070 > $DCC_PATH/config
    echo 0xFB90810 > $DCC_PATH/config
    echo 0xFB93500 > $DCC_PATH/config
    echo 0xFB93A84 > $DCC_PATH/config
    echo 0xFBA0008 > $DCC_PATH/config
    echo 0xFBA0020 2 > $DCC_PATH/config
    echo 0xFBA0070 > $DCC_PATH/config
    echo 0xFBA0810 > $DCC_PATH/config
    echo 0xFBA3500 > $DCC_PATH/config
    echo 0xFBA3A84 2 > $DCC_PATH/config

    #SAW register
    echo 0xF900C14 2 > $DCC_PATH/config
    echo 0xF901C14 2 > $DCC_PATH/config
    echo 0xF900C0C > $DCC_PATH/config #SILVER_SAW4_SRM_STS
    echo 0xF901C0C > $DCC_PATH/config #GOLD_SAW4_SRM_STS
}

config_dcc_rimps()
{
    #RIMPS Debug register
    echo 0xFD80110 9 > $DCC_PATH/config
    echo 0xFD9001C 3 > $DCC_PATH/config
    echo 0xFD90090 > $DCC_PATH/config
    echo 0xFD900B0 2 > $DCC_PATH/config
    echo 0xFD900D8 > $DCC_PATH/config
    echo 0xFD900E8 > $DCC_PATH/config
    echo 0xFD90300 > $DCC_PATH/config
    echo 0xFD90320 > $DCC_PATH/config
    echo 0xFD90348 3 > $DCC_PATH/config
    echo 0xFD90360 > $DCC_PATH/config
    echo 0xFD90368 2 > $DCC_PATH/config
    echo 0xFD9101C 3 > $DCC_PATH/config
    echo 0xFD91090 > $DCC_PATH/config
    echo 0xFD910B0 2 > $DCC_PATH/config
    echo 0xFD910D8 > $DCC_PATH/config
    echo 0xFD910E8 > $DCC_PATH/config
    echo 0xFD91300 > $DCC_PATH/config
    echo 0xFD91320 > $DCC_PATH/config
    echo 0xFD91348 3 > $DCC_PATH/config
    echo 0xFD91360 > $DCC_PATH/config
    echo 0xFD91368 2 > $DCC_PATH/config
    echo 0xFD9201C 3 > $DCC_PATH/config
    echo 0xFD92090 > $DCC_PATH/config
    echo 0xFD920B0 2 > $DCC_PATH/config
    echo 0xFD920D8 > $DCC_PATH/config
    echo 0xFD920E8 > $DCC_PATH/config
    echo 0xFD92300 > $DCC_PATH/config
    echo 0xFD92320 > $DCC_PATH/config
    echo 0xFD92348 4 > $DCC_PATH/config
    echo 0xFD92360 > $DCC_PATH/config
    echo 0xFD92368 2 > $DCC_PATH/config
    echo 0xFD98004 > $DCC_PATH/config
    echo 0xFD98018 3 > $DCC_PATH/config
}

config_dcc_noc()
{
    #SNOC Sensein register
    echo 0x1880240 1 > $DCC_PATH/config
    echo 0x1880248 1 > $DCC_PATH/config
    echo 0x1880300 8 > $DCC_PATH/config
    echo 0x1880700 4 > $DCC_PATH/config
    echo 0x1880714 3 > $DCC_PATH/config
    echo 0x1881100 2 > $DCC_PATH/config

    #SNOC Errorlogger register
    echo 0x1880104 2 > $DCC_PATH/config
    echo 0x1880110 > $DCC_PATH/config
    echo 0x1880120 8 > $DCC_PATH/config

    #CNOC Sensein
    echo 0x1900240 5 > $DCC_PATH/config
    echo 0x1900258 > $DCC_PATH/config
    echo 0x1900500 8 > $DCC_PATH/config
    echo 0x1900900 > $DCC_PATH/config
    echo 0x1900D00 2 > $DCC_PATH/config

    #CNOC Errorlogger register
    echo 0x1900000 > $DCC_PATH/config
    echo 0x1900010 > $DCC_PATH/config
    echo 0x1900020 8 > $DCC_PATH/config

    #GCC
    echo 0x1480014 > $DCC_PATH/config
    echo 0x1480140 > $DCC_PATH/config
    echo 0x1481140 > $DCC_PATH/config
}

config_dcc_gpu()
{
    #GCC Register
    echo 0x1429024 > $DCC_PATH/config
    echo 0x1436004 3 > $DCC_PATH/config
    echo 0x1436014 2 > $DCC_PATH/config
    echo 0x1442054 > $DCC_PATH/config
    echo 0x145B1E4 2 > $DCC_PATH/config
    echo 0x1471154 > $DCC_PATH/config
    echo 0x147B03C > $DCC_PATH/config
    echo 0x147B06C > $DCC_PATH/config
    echo 0x147C000 > $DCC_PATH/config
    echo 0x147C03C > $DCC_PATH/config
    echo 0x147D000 > $DCC_PATH/config
    echo 0x147D070 > $DCC_PATH/config
    echo 0x147E0A0 2 > $DCC_PATH/config
    echo 0x1487064 2 > $DCC_PATH/config

    #GPUCC register
    echo 0x5900410 2 > $DCC_PATH/config
    echo 0x5902018 > $DCC_PATH/config
    echo 0x5991004 > $DCC_PATH/config
    echo 0x599100C 2 > $DCC_PATH/config
    echo 0x5991054 5  > $DCC_PATH/config
    echo 0x599106C 2  > $DCC_PATH/config
    echo 0x5991070  > $DCC_PATH/config
    echo 0x5991078 10 > $DCC_PATH/config
    echo 0x59910A4 2  > $DCC_PATH/config
    echo 0x59910F0 2  > $DCC_PATH/config
    echo 0x5991100  > $DCC_PATH/config
    echo 0x599110C  > $DCC_PATH/config
    echo 0x5991118  > $DCC_PATH/config
    echo 0x5991164 2  > $DCC_PATH/config
    echo 0x5991534  > $DCC_PATH/config
    echo 0x5991540 > $DCC_PATH/config
    echo 0x5992000 2  > $DCC_PATH/config
    echo 0x5993000 2  > $DCC_PATH/config
    echo 0x5994000 2 > $DCC_PATH/config
    echo 0x5995000 2  > $DCC_PATH/config
    echo 0x5996000 2  > $DCC_PATH/config
    echo 0x5997000 2  > $DCC_PATH/config

    # S2 Fault
    echo 0x593D000 > $DCC_PATH/config
    echo 0x593C000 > $DCC_PATH/config

    # SMMU debug registers
    echo 0x5946050 2 > $DCC_PATH/config

    #RBBM
    echo 0x59002B4 2 > $DCC_PATH/config
    echo 0x5900800 > $DCC_PATH/config
    echo 0x5900818 > $DCC_PATH/config
    echo 0x5900840 4 > $DCC_PATH/config
    echo 0x5900804 > $DCC_PATH/config
    echo 0x598EC30 2 > $DCC_PATH/config
    echo 0x59000E0 > $DCC_PATH/config
    echo 0x596A204 > $DCC_PATH/config
    echo 0x597E340 > $DCC_PATH/config

    echo 0x1413004 > $DCC_PATH/config #GCC_IMEM_AXI_CBCR
}

config_dcc_gcc()
{
    #GCC
    echo 0x1400000 > $DCC_PATH/config
    echo 0x1400038 > $DCC_PATH/config
    echo 0x1401000 > $DCC_PATH/config
    echo 0x1401038 > $DCC_PATH/config
    echo 0x1402000 > $DCC_PATH/config
    echo 0x1402038 > $DCC_PATH/config
    echo 0x1403000 > $DCC_PATH/config
    echo 0x1403038 > $DCC_PATH/config
    echo 0x1404000 > $DCC_PATH/config
    echo 0x1404038 > $DCC_PATH/config
    echo 0x1405000 > $DCC_PATH/config
    echo 0x1405038 > $DCC_PATH/config
    echo 0x1406000 > $DCC_PATH/config
    echo 0x1406038 > $DCC_PATH/config
    echo 0x1407000 > $DCC_PATH/config
    echo 0x1407038 > $DCC_PATH/config
    echo 0x1408000 > $DCC_PATH/config
    echo 0x1408038 > $DCC_PATH/config
    echo 0x1409000 > $DCC_PATH/config
    echo 0x1409028 > $DCC_PATH/config
    echo 0x140A000 > $DCC_PATH/config
    echo 0x140A038 > $DCC_PATH/config
    echo 0x140B000 > $DCC_PATH/config
    echo 0x140B038 > $DCC_PATH/config
    echo 0x140C000 > $DCC_PATH/config
    echo 0x140C038 > $DCC_PATH/config
    echo 0x1465000 > $DCC_PATH/config
    echo 0x440C040 > $DCC_PATH/config
    echo 0x440C080 > $DCC_PATH/config
    echo 0x141001C > $DCC_PATH/config
    echo 0x14103EC > $DCC_PATH/config
    echo 0x1414024 > $DCC_PATH/config
    echo 0x1415034 > $DCC_PATH/config
    echo 0x1416038 > $DCC_PATH/config
    echo 0x141F02C > $DCC_PATH/config
    echo 0x141F15C > $DCC_PATH/config
    echo 0x141F28C > $DCC_PATH/config
    echo 0x141F3BC > $DCC_PATH/config
    echo 0x141F4EC > $DCC_PATH/config
    echo 0x141F61C > $DCC_PATH/config
    echo 0x141F74C > $DCC_PATH/config
    echo 0x1427024 > $DCC_PATH/config
    echo 0x1432034 > $DCC_PATH/config
    echo 0x1446024 > $DCC_PATH/config
    echo 0x1446150 > $DCC_PATH/config
    echo 0x1453030 > $DCC_PATH/config
    echo 0x1453160 > $DCC_PATH/config
    echo 0x1453290 > $DCC_PATH/config
    echo 0x14533C0 > $DCC_PATH/config
    echo 0x14534F0 > $DCC_PATH/config
    echo 0x1453620 > $DCC_PATH/config
    echo 0x146F024 > $DCC_PATH/config
    echo 0x1472024 > $DCC_PATH/config
    echo 0x146B000 > $DCC_PATH/config
    echo 0x146B004 > $DCC_PATH/config
    echo 0x146B008 > $DCC_PATH/config
    echo 0x146B00C > $DCC_PATH/config
    echo 0x146B010 > $DCC_PATH/config
    echo 0x146B014 > $DCC_PATH/config
    echo 0x146B018 > $DCC_PATH/config
    echo 0x146B01C > $DCC_PATH/config
    echo 0x146B020 > $DCC_PATH/config
    echo 0x146B024 > $DCC_PATH/config
    echo 0x146B028 > $DCC_PATH/config
    echo 0x1415004 > $DCC_PATH/config
    echo 0x1415008 > $DCC_PATH/config
    echo 0x141500C > $DCC_PATH/config
    echo 0x1416004 > $DCC_PATH/config
    echo 0x1416008 > $DCC_PATH/config
    echo 0x141600C > $DCC_PATH/config
    echo 0x142A000 > $DCC_PATH/config
    echo 0x1432004 > $DCC_PATH/config
    echo 0x1445004 > $DCC_PATH/config
    echo 0x1458004 > $DCC_PATH/config
    echo 0x145807C > $DCC_PATH/config
    echo 0x1458098 > $DCC_PATH/config
    echo 0x141A004 > $DCC_PATH/config
    echo 0x1429004 > $DCC_PATH/config
    echo 0x1414004 > $DCC_PATH/config
    echo 0x1414008 > $DCC_PATH/config
    echo 0x1483140 > $DCC_PATH/config
    echo 0x1415010 > $DCC_PATH/config
    echo 0x1416010 > $DCC_PATH/config
    echo 0x142A00C > $DCC_PATH/config
    echo 0x1447004 > $DCC_PATH/config
    echo 0x1449004 > $DCC_PATH/config
    echo 0x149E0C4 > $DCC_PATH/config
    echo 0x1457000 > $DCC_PATH/config
    echo 0x145A000 > $DCC_PATH/config
    echo 0x145B000 > $DCC_PATH/config
    echo 0x1469000 > $DCC_PATH/config
    echo 0x146C000 > $DCC_PATH/config
    echo 0x1475000 > $DCC_PATH/config
    echo 0x1477000 > $DCC_PATH/config
    echo 0x1479000 > $DCC_PATH/config
    echo 0x147A000 > $DCC_PATH/config
    echo 0x1482000 > $DCC_PATH/config
    echo 0x1495000 > $DCC_PATH/config
    echo 0x146D000 > $DCC_PATH/config
    echo 0x1457004 > $DCC_PATH/config
    echo 0x145700C > $DCC_PATH/config
    echo 0x145A004 > $DCC_PATH/config
    echo 0x145A00C > $DCC_PATH/config
    echo 0x145B004 > $DCC_PATH/config
    echo 0x145B00C > $DCC_PATH/config
    echo 0x1469004 > $DCC_PATH/config
    echo 0x146900C > $DCC_PATH/config
    echo 0x146C004 > $DCC_PATH/config
    echo 0x146C00C > $DCC_PATH/config
    echo 0x1475004 > $DCC_PATH/config
    echo 0x147500C > $DCC_PATH/config
    echo 0x1477004 > $DCC_PATH/config
    echo 0x147700C > $DCC_PATH/config
    echo 0x1479004 > $DCC_PATH/config
    echo 0x147900C > $DCC_PATH/config
    echo 0x147A004 > $DCC_PATH/config
    echo 0x147A00C > $DCC_PATH/config
    echo 0x1482004 > $DCC_PATH/config
    echo 0x148200C > $DCC_PATH/config
    echo 0x1495004 > $DCC_PATH/config
    echo 0x149500C > $DCC_PATH/config

    ##MAPSS_CC


}

config_dcc_ddr()
{
    echo 0x4480040 2 > $DCC_PATH/config
    echo 0x4480810 2 > $DCC_PATH/config
    echo 0x4488100 > $DCC_PATH/config
    echo 0x4488400 2 > $DCC_PATH/config
    echo 0x4488410 > $DCC_PATH/config
    echo 0x4488420 2 > $DCC_PATH/config
    echo 0x4488430 2 > $DCC_PATH/config
    echo 0x4488440 2 > $DCC_PATH/config
    echo 0x4488450 > $DCC_PATH/config
    echo 0x448c100 > $DCC_PATH/config
    echo 0x448c400 2 > $DCC_PATH/config
    echo 0x448c410 > $DCC_PATH/config
    echo 0x448c420 2 > $DCC_PATH/config
    echo 0x448c430 2 > $DCC_PATH/config
    echo 0x448c440 2 > $DCC_PATH/config
    echo 0x448c450 > $DCC_PATH/config
    echo 0x4490100 > $DCC_PATH/config
    echo 0x4490400 2 > $DCC_PATH/config
    echo 0x4490410 > $DCC_PATH/config
    echo 0x4490420 2 > $DCC_PATH/config
    echo 0x4490430 2 > $DCC_PATH/config
    echo 0x4490440 2 > $DCC_PATH/config
    echo 0x4490450 > $DCC_PATH/config
    echo 0x4494100 > $DCC_PATH/config
    echo 0x4494400 2 > $DCC_PATH/config
    echo 0x4494410 > $DCC_PATH/config
    echo 0x4494420 2 > $DCC_PATH/config
    echo 0x4494430 2 > $DCC_PATH/config
    echo 0x4494440 2 > $DCC_PATH/config
    echo 0x4494450 > $DCC_PATH/config
    echo 0x4498100 > $DCC_PATH/config
    echo 0x4498400 2 > $DCC_PATH/config
    echo 0x4498410 > $DCC_PATH/config
    echo 0x4498420 2 > $DCC_PATH/config
    echo 0x4498430 2 > $DCC_PATH/config
    echo 0x4498440 2 > $DCC_PATH/config
    echo 0x4498450 > $DCC_PATH/config
    echo 0x449c400 2 > $DCC_PATH/config
    echo 0x449c420 2 > $DCC_PATH/config
    echo 0x449c430 > $DCC_PATH/config
    echo 0x449c440 2 > $DCC_PATH/config
    echo 0x449c450 > $DCC_PATH/config
    echo 0x44a0400 2 > $DCC_PATH/config
    echo 0x44a0420 2 > $DCC_PATH/config
    echo 0x44a0430 > $DCC_PATH/config
    echo 0x44a0440 2 > $DCC_PATH/config
    echo 0x44a0450 > $DCC_PATH/config
    echo 0x44a4100 > $DCC_PATH/config
    echo 0x44a4400 2 > $DCC_PATH/config
    echo 0x44a4410 > $DCC_PATH/config
    echo 0x44a4420 2 > $DCC_PATH/config
    echo 0x44a4430 2 > $DCC_PATH/config
    echo 0x44a4440 2 > $DCC_PATH/config
    echo 0x44a4450 > $DCC_PATH/config
    echo 0x44b0020 > $DCC_PATH/config
    echo 0x44b0100 > $DCC_PATH/config
    echo 0x44b0120 5 > $DCC_PATH/config
    echo 0x44b0140 > $DCC_PATH/config
    echo 0x44b0450 > $DCC_PATH/config
    echo 0x44b0500 > $DCC_PATH/config
    echo 0x44b0520 > $DCC_PATH/config
    echo 0x44b0560 > $DCC_PATH/config
    echo 0x44b05a0 > $DCC_PATH/config
    echo 0x44b0710 > $DCC_PATH/config
    echo 0x44b0720 > $DCC_PATH/config
    echo 0x44b0a40 > $DCC_PATH/config
    echo 0x44b1800 > $DCC_PATH/config
    echo 0x44b408c > $DCC_PATH/config
    echo 0x44b409c 3 > $DCC_PATH/config
    echo 0x44b40b8 > $DCC_PATH/config
    echo 0x44b5070 2 > $DCC_PATH/config
    echo 0x44bc020 > $DCC_PATH/config
    echo 0x44bc100 > $DCC_PATH/config
    echo 0x44bc120 4 > $DCC_PATH/config
    echo 0x44bc140 > $DCC_PATH/config
    echo 0x44bc450 > $DCC_PATH/config
    echo 0x44bc500 > $DCC_PATH/config
    echo 0x44bc520 > $DCC_PATH/config
    echo 0x44bc560 > $DCC_PATH/config
    echo 0x44bc5a0 > $DCC_PATH/config
    echo 0x44bc710 > $DCC_PATH/config
    echo 0x44bc720 > $DCC_PATH/config
    echo 0x44bca40 > $DCC_PATH/config
    echo 0x44bd800 > $DCC_PATH/config
    echo 0x44c008c > $DCC_PATH/config
    echo 0x44c009c 3 > $DCC_PATH/config
    echo 0x44c00b8 > $DCC_PATH/config
    echo 0x44c1070 2 > $DCC_PATH/config
    echo 0x44c8220 > $DCC_PATH/config
    echo 0x44c8400 7 > $DCC_PATH/config
    echo 0x44c8420 9 > $DCC_PATH/config
    echo 0x44c9800 > $DCC_PATH/config
    echo 0x44d0000 > $DCC_PATH/config
    echo 0x44d0020 > $DCC_PATH/config
    echo 0x44d0030 > $DCC_PATH/config
    echo 0x44d0100 > $DCC_PATH/config
    echo 0x44d0108 2 > $DCC_PATH/config
    echo 0x44d0400 > $DCC_PATH/config
    echo 0x44d0410 > $DCC_PATH/config
    echo 0x44d0420 > $DCC_PATH/config
    echo 0x44d1800 > $DCC_PATH/config
    echo 0x450002c 2 > $DCC_PATH/config
    echo 0x4500094 > $DCC_PATH/config
    echo 0x450009c > $DCC_PATH/config
    echo 0x45000c4 2 > $DCC_PATH/config
    echo 0x45003dc > $DCC_PATH/config
    echo 0x45005d8 > $DCC_PATH/config
    echo 0x450202c 2 > $DCC_PATH/config
    echo 0x4502094 > $DCC_PATH/config
    echo 0x450209c > $DCC_PATH/config
    echo 0x45020c4 2 > $DCC_PATH/config
    echo 0x45023dc > $DCC_PATH/config
    echo 0x45025d8 > $DCC_PATH/config
    echo 0x450302c 2 > $DCC_PATH/config
    echo 0x4503094 > $DCC_PATH/config
    echo 0x450309c > $DCC_PATH/config
    echo 0x45030c4 2 > $DCC_PATH/config
    echo 0x45033dc > $DCC_PATH/config
    echo 0x45035d8 > $DCC_PATH/config
    echo 0x4506028 2 > $DCC_PATH/config
    echo 0x4506044 > $DCC_PATH/config
    echo 0x4506094 > $DCC_PATH/config
    echo 0x45061dc > $DCC_PATH/config
    echo 0x45061ec > $DCC_PATH/config
    echo 0x4506608 > $DCC_PATH/config
    echo 0x450702c 2 > $DCC_PATH/config
    echo 0x4507094 > $DCC_PATH/config
    echo 0x450709c > $DCC_PATH/config
    echo 0x45070c4 2 > $DCC_PATH/config
    echo 0x45073dc > $DCC_PATH/config
    echo 0x45075d8 > $DCC_PATH/config
    echo 0x450902c 2 > $DCC_PATH/config
    echo 0x4509094 > $DCC_PATH/config
    echo 0x450909c > $DCC_PATH/config
    echo 0x45090c4 2 > $DCC_PATH/config
    echo 0x45093dc > $DCC_PATH/config
    echo 0x45095d8 > $DCC_PATH/config
    echo 0x450a02c 2 > $DCC_PATH/config
    echo 0x450a094 3 > $DCC_PATH/config
    echo 0x450a0c4 2 > $DCC_PATH/config
    echo 0x450a3dc > $DCC_PATH/config
    echo 0x450a5d8 > $DCC_PATH/config
}

config_dcc_modem_rsc()
{
    #Modem RSC register
    echo 0x6130010 3 > $DCC_PATH/config
    echo 0x6130208 3 > $DCC_PATH/config
    echo 0x6130228 3 > $DCC_PATH/config
    echo 0x6130248 3 > $DCC_PATH/config
    echo 0x6130268 3 > $DCC_PATH/config
    echo 0x6130288 3 > $DCC_PATH/config
    echo 0x61302A8 3 > $DCC_PATH/config
    echo 0x6130400 3 > $DCC_PATH/config

    #Modem RSCp Register
    echo 0x6200000 19 > $DCC_PATH/config
    echo 0x62000d0 > $DCC_PATH/config
    echo 0x62000d8 > $DCC_PATH/config
    echo 0x6200100 > $DCC_PATH/config
    echo 0x6200108 > $DCC_PATH/config
    echo 0x6200200 5 > $DCC_PATH/config
    echo 0x6200224 4 > $DCC_PATH/config
    echo 0x6200244 4 > $DCC_PATH/config
    echo 0x6200264 4 > $DCC_PATH/config
    echo 0x6200284 4 > $DCC_PATH/config
    echo 0x62002a4 4 > $DCC_PATH/config
    echo 0x6200400 3 > $DCC_PATH/config
    echo 0x6200450 6 > $DCC_PATH/config
    echo 0x6200490 11 > $DCC_PATH/config
    echo 0x6210000 19 > $DCC_PATH/config
    echo 0x62100d0 > $DCC_PATH/config
    echo 0x62100d8 > $DCC_PATH/config
    echo 0x6210100 > $DCC_PATH/config
    echo 0x6210108 > $DCC_PATH/config
    echo 0x6210204 4 > $DCC_PATH/config
    echo 0x6210224 4 > $DCC_PATH/config
    echo 0x6210244 4 > $DCC_PATH/config
    echo 0x6210264 4 > $DCC_PATH/config
    echo 0x6210284 4 > $DCC_PATH/config
    echo 0x62102a4 4 > $DCC_PATH/config
    echo 0x6210400 3 > $DCC_PATH/config
    echo 0x6210450 6 > $DCC_PATH/config
    echo 0x62104a0 7 > $DCC_PATH/config

    echo 0x0143300C > $DCC_PATH/config
    echo 0x6082028 > $DCC_PATH/config
    echo 0x61A802C > $DCC_PATH/config
}

config_dcc_lpass()
{
    #LPASS PDC register
    echo 0xA750010 2 > $DCC_PATH/config
    echo 0xA750900 2 > $DCC_PATH/config
    echo 0xA751020 2 > $DCC_PATH/config
    echo 0xA751030 > $DCC_PATH/config
    echo 0xA751200 3 > $DCC_PATH/config
    echo 0xA751214 3 > $DCC_PATH/config
    echo 0xA751228 3 > $DCC_PATH/config
    echo 0xA75123C 3 > $DCC_PATH/config
    echo 0xA751250 3 > $DCC_PATH/config
    echo 0xA754510 2 > $DCC_PATH/config
    echo 0xA754520 > $DCC_PATH/config

    #LPASS RSC register
    echo 0x0A900014 2 > $DCC_PATH/config
    echo 0x0A900030 > $DCC_PATH/config
    echo 0x0A900038 > $DCC_PATH/config
    echo 0x0A900040 > $DCC_PATH/config
    echo 0x0A900048 > $DCC_PATH/config
    echo 0x0A9000D0 > $DCC_PATH/config
    echo 0x0A900208 3 > $DCC_PATH/config
    echo 0x0A900228 3 > $DCC_PATH/config
    echo 0x0A900248 3 > $DCC_PATH/config
    echo 0x0A900268 3 > $DCC_PATH/config
    echo 0x0A900288 3 > $DCC_PATH/config
    echo 0x0A9002A8 3 > $DCC_PATH/config
    echo 0x0A900400 3 > $DCC_PATH/config
    echo 0x0A900D04 > $DCC_PATH/config

    #LPASS QDSP RSC register
    echo 0x0A4B0010 3 > $DCC_PATH/config
    echo 0x0A4B0208 3 > $DCC_PATH/config
    echo 0x0A4B0228 3 > $DCC_PATH/config
    echo 0x0A4B0248 3 > $DCC_PATH/config
    echo 0x0A4B0268 3 > $DCC_PATH/config
    echo 0x0A4B0288 3 > $DCC_PATH/config
    echo 0x0A4B02A8 3 > $DCC_PATH/config
    echo 0x0A4B0400 3 > $DCC_PATH/config

    echo 0x440B008 4 > $DCC_PATH/config
    echo 0xA402028 > $DCC_PATH/config

    #MSS_QDSP6SS_CORE_STATUS
    echo 0x6082028  > $DCC_PATH/config

    #LPASS_QDSP6SS_DBG_NMI_PWR_STATUS
    echo 0xA400304  > $DCC_PATH/config

    #MSS_QDSP6SS_DBG_NMI_PWR_STATUS
    echo 0x6080304  > $DCC_PATH/config

    #MPM_SSCAON_STATUS0
    echo 0x440B00C  > $DCC_PATH/config

    #MPM_SSCAON_STATUS1
    echo 0x440B014  > $DCC_PATH/config
}

config_dcc_cdsp()
{
    #CDSP Turing RSC register
    echo 0xB3B0010 3 > $DCC_PATH/config
    echo 0xB3B0208 3 > $DCC_PATH/config
    echo 0xB3B0228 3 > $DCC_PATH/config
    echo 0xB3B0248 3 > $DCC_PATH/config
    echo 0xB3B0268 3 > $DCC_PATH/config
    echo 0xB3B0288 3 > $DCC_PATH/config
    echo 0xB3B02A8 3 > $DCC_PATH/config
    echo 0xB3B0400 3 > $DCC_PATH/config

    echo 0xB302028 > $DCC_PATH/config
    echo 0xB300044 > $DCC_PATH/config
    echo 0xB300304 > $DCC_PATH/config
}

config_dcc_limit()
{
    #Central boradcast register
    echo 0x4414010 1 > $DCC_PATH/config
    echo 0x44140B0 1 > $DCC_PATH/config
    echo 0x44140C0 3 > $DCC_PATH/config
    echo 0x44140E0 8 > $DCC_PATH/config
    echo 0x4414100 16 > $DCC_PATH/config
    echo 0x4414140 16 > $DCC_PATH/config

    #Gold LLM register
    echo 0x0FB70220 2 > $DCC_PATH/config
    echo 0x0FB702A0 2 > $DCC_PATH/config
    echo 0x0FB704A0 12 > $DCC_PATH/config
    echo 0x0FB70520 1 > $DCC_PATH/config
    echo 0x0FB70588 1 > $DCC_PATH/config
    echo 0x0FB70D10 8 > $DCC_PATH/config
    echo 0x0FB70F90 6 > $DCC_PATH/config
    echo 0x0FB71010 6 > $DCC_PATH/config
    echo 0x0FB71A10 4 > $DCC_PATH/config

    #Silver LLM resister
    echo 0x0FB784A0 12 > $DCC_PATH/config
    echo 0x0FB78520 1 > $DCC_PATH/config
    echo 0x0FB78588 1 > $DCC_PATH/config
    echo 0x0FB78D10 8 > $DCC_PATH/config
    echo 0x0FB78F90 6 > $DCC_PATH/config
    echo 0x0FB79010 6 > $DCC_PATH/config
    echo 0x0FB79A10 4 > $DCC_PATH/config
}

config_dcc_wdog()
{
    echo 0xF400038 > $DCC_PATH/config
    echo 0xF41000C > $DCC_PATH/config
    echo 0xF400438 > $DCC_PATH/config

    #Core hang thresold
    echo 0xF800058 > $DCC_PATH/config
    echo 0xF810058 > $DCC_PATH/config
    echo 0xF820058 > $DCC_PATH/config
    echo 0xF830058 > $DCC_PATH/config
    echo 0xF840058 > $DCC_PATH/config
    echo 0xF850058 > $DCC_PATH/config
    echo 0xF860058 > $DCC_PATH/config
    echo 0xF870058 > $DCC_PATH/config

    #Core hang config
    echo 0xF800060 > $DCC_PATH/config
    echo 0xF810060 > $DCC_PATH/config
    echo 0xF820060 > $DCC_PATH/config
    echo 0xF830060 > $DCC_PATH/config
    echo 0xF840060 > $DCC_PATH/config
    echo 0xF850060 > $DCC_PATH/config
    echo 0xF860060 > $DCC_PATH/config
    echo 0xF870060 > $DCC_PATH/config

    #GNOC hang
    echo 0xF600440 > $DCC_PATH/config
    echo 0xF60043C > $DCC_PATH/config
    echo 0xF600404 > $DCC_PATH/config

    #Secure bite register
    echo 0x4407000 5 > $DCC_PATH/config

    #MPM_READ_CNTCV_LO
    echo 0x4402000 2 > $DCC_PATH/config
}

config_dcc_gic()
{
    echo 0xF200104 29 > $DCC_PATH/config
    echo 0xF200184 29 > $DCC_PATH/config
    echo 0xF200204 29 > $DCC_PATH/config
    echo 0xF200284 29 > $DCC_PATH/config
    echo 0xF25C000 > $DCC_PATH/config #APSS_ALIAS0_GICR_MISCSTATUSR
    echo 0xF27C000 > $DCC_PATH/config #APSS_ALIAS1_GICR_MISCSTATUSR
    echo 0xF29C000 > $DCC_PATH/config #APSS_ALIAS2_GICR_MISCSTATUSR
    echo 0xF2BC000 > $DCC_PATH/config #APSS_ALIAS3_GICR_MISCSTATUSR
    echo 0xF2DC000 > $DCC_PATH/config #APSS_ALIAS4_GICR_MISCSTATUSR
    echo 0xF2FC000 > $DCC_PATH/config #APSS_ALIAS5_GICR_MISCSTATUSR
    echo 0xF31C000 > $DCC_PATH/config #APSS_ALIAS6_GICR_MISCSTATUSR
    echo 0xF33C000 > $DCC_PATH/config #APSS_ALIAS7_GICR_MISCSTATUSR
}

config_dcc_tsens()
{
    #Tsens register
    echo 0x04410004 1 > $DCC_PATH/config
    echo 0x4411014 1 > $DCC_PATH/config
    echo 0x44110E0 1 > $DCC_PATH/config
    echo 0x44110EC 1 > $DCC_PATH/config
    echo 0x44110A0 16 > $DCC_PATH/config
    echo 0x44110E8 1 > $DCC_PATH/config
    echo 0x4410010 1 > $DCC_PATH/config
    echo 0x441113C 1 > $DCC_PATH/config
    echo 0x4412004 1 > $DCC_PATH/config
    echo 0x4413014 1 > $DCC_PATH/config
    echo 0x44130E0 1 > $DCC_PATH/config
    echo 0x44130EC 1 > $DCC_PATH/config
    echo 0x44130A0 16 > $DCC_PATH/config
    echo 0x44130E8 1 > $DCC_PATH/config
    echo 0x441313C 1 > $DCC_PATH/config
    echo 0x4412010 1 > $DCC_PATH/config
}

enable_dcc()
{
    DCC_PATH="/sys/bus/platform/devices/16db000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_dcc_core_hang
    config_dcc_pcu
    config_dcc_pimem
    config_dcc_cpr
    config_dcc_rimps
    config_dcc_noc
    config_dcc_wdog
    config_dcc_gic
    config_dcc_tsens

    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_dcc_ddr
    config_dcc_gpu
    config_dcc_gcc
    config_dcc_modem_rsc
    config_dcc_cdsp
    config_dcc_lpass
    config_dcc_limit

    echo  1 > $DCC_PATH/enable
}

enable_core_hang_config()
{
    CORE_PATH="/sys/devices/system/cpu/hang_detect_core"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH/threshold

    #To enable core hang detection
    #It's a boolean variable. Do not use Hex value to enable/disable
    echo 1 > $CORE_PATH/enable
}

adjust_permission()
{
    #add permission for block_size, mem_type, mem_size nodes to collect diag over QDSS by ODL
    #application by "oem_2902" group
    chown -h root.oem_2902 /sys/devices/platform/soc/8048000.tmc/coresight-tmc-etr/block_size
    chmod 660 /sys/devices/platform/soc/8048000.tmc/coresight-tmc-etr/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/8048000.tmc/coresight-tmc-etr/buffer_size
    chmod 660 /sys/devices/platform/soc/8048000.tmc/coresight-tmc-etr/buffer_size
}

enable_schedstats()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    if [ -f /proc/sys/kernel/sched_schedstats ]
    then
        echo 1 > /proc/sys/kernel/sched_schedstats
    fi
}

enable_cpuss_register()
{
    echo 1 > /sys/bus/platform/devices/soc:mem_dump/register_reset
    format_ver=1
    if [ -r /sys/bus/platform/devices/soc:mem_dump/format_version ]; then
        format_ver=$(cat /sys/bus/platform/devices/soc:mem_dump/format_version)
    fi
    MEM_DUMP_PATH="/sys/bus/platform/devices/soc:mem_dump"

    echo 0xf000000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf000008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf000054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf0000f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf008000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf200000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf200020 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf200084 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200284 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200304 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200384 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200420 0x3a0 > $MEM_DUMP_PATH/register_config
    echo 0xf200c08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf200d04 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf200e08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf206100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2061f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2062f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2063f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2064f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2065f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2066f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2067f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2068f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2069f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206e98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ea0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ea8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206eb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206eb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ec0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ec8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ed0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ed8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ee0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ee8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ef0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ef8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206f98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206fe8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf206ff8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2070f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2071f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2072f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2073f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2074f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2075f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2076f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2077f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2078f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2079f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf207df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf20e008 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf20e104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf20f000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf20ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf220000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2200e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2201e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf220228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22e000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22e800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22e808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22ffbc 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22ffc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf22ffd0 0x44 > $MEM_DUMP_PATH/register_config
    echo 0xf230400 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf230600 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf230a00 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf230c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230e00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf230e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf230fb8 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf230fcc 0x34 > $MEM_DUMP_PATH/register_config
    echo 0xf240000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf240014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf240020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf24ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf250080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf250c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf250d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf250e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf25c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf25c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf25c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf25f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf260000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf260014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf260020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf26ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf270080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf270c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf270d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf270e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf27c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf27c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf27c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf27f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf280000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf280014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf280020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf28ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf290080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf290c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf290d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf290e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf29c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf29c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf29c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf29f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2a0000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2a0014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2a0020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2affd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf2b0080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf2b0c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2b0d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2b0e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2bc000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2bc008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2bc010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2bf000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2c0000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2c0014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2c0020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2cffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf2d0080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf2d0c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2d0d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2d0e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2dc000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2dc008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2dc010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2df000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2e0000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2e0014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2e0020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf2effd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf2f0080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf2f0c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf2f0d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2f0e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2fc000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2fc008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2fc010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf2ff000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf300000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf300014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf300020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf30ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf310080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf310c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf310d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf310e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf31c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf31c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf31c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf31f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf320000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf320014 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf320020 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf32ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf330080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf330c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf330d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf330e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf33c000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf33c008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf33c010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf33f000 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf340000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf340020 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf340084 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340184 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340204 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340284 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340304 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340384 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340420 0x3a0 > $MEM_DUMP_PATH/register_config
    echo 0xf340c08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf340d04 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf340e08 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf346100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3461f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3462f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3463f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3464f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3465f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3466f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3467f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3468f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3469f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346e98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ea0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ea8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346eb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346eb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ec0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ec8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ed0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ed8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ee0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ee8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ef0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ef8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346f98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346fe8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf346ff8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3470f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347128 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347130 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347138 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347148 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347150 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347158 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347160 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347168 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347178 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347180 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347188 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347198 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3471f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347200 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347208 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347210 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347218 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347220 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347228 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347230 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347238 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347240 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347248 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347250 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347258 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347260 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347268 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347270 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347278 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347280 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347288 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347290 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347298 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3472f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347300 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347308 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347310 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347318 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347328 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347330 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347338 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347340 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347348 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347350 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347358 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347360 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347368 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347370 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347378 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347388 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347390 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347398 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3473f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347400 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347408 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347418 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347420 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347428 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347430 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347440 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347448 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347450 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347458 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347460 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347468 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347470 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347478 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347480 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347488 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347490 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347498 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3474f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347500 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347508 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347510 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347518 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347520 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347528 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347530 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347538 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347540 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347548 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347550 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347558 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347560 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347568 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347570 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347578 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347580 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347588 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347590 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347598 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3475f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347608 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347610 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347618 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347620 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347628 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347630 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347638 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347640 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347648 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347650 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347658 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347660 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347668 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347670 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347678 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347680 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347688 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347690 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347698 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3476f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347708 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347710 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347718 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347720 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347728 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347730 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347738 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347740 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347748 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347750 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347758 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347760 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347768 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347770 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347778 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347780 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347788 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347790 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347798 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3477f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347800 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347808 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347810 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347818 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347820 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347828 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347830 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347838 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347840 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347848 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347850 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347858 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347860 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347868 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347870 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347878 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347880 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347888 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347890 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347898 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3478f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347900 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347908 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347910 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347918 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347920 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347928 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347930 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347938 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347940 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347948 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347950 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347958 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347960 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347968 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347970 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347978 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347980 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347988 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347990 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347998 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf3479f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347a98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347aa0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347aa8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ab0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ab8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ac0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ac8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ad0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ad8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ae0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ae8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347af0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347af8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347b98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ba8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347be0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347be8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347bf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347c98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ca0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ca8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cb0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cb8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ce0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347ce8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cf0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347cf8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d08 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d10 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d18 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d20 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d28 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d30 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d38 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d40 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d48 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d50 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d58 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d60 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d68 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d70 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d78 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d88 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d90 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347d98 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347da0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347da8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347db0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347db8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347dc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347dc8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347dd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347dd8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347de0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347de8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347df0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf347df8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf34e008 0xe8 > $MEM_DUMP_PATH/register_config
    echo 0xf34e104 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf34f000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf34ffd0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xf400004 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf400038 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf400044 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf4000f0 0x74 > $MEM_DUMP_PATH/register_config
    echo 0xf400438 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf400444 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf410000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf41000c 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf410020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf420000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf420040 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf420080 0x38 > $MEM_DUMP_PATH/register_config
    echo 0xf420fc0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf420fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf420fe0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf420ff0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf421000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf421fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf422000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf422020 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf422fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf423000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf423fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf425000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf425fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf426000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf426020 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf426fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf427000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf427fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf429000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf429fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf42b000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf42bfd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf42d000 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf42dfd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf600004 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf60002c 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf600040 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600050 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf600070 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf600160 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf600204 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600210 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600220 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf600230 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600240 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xf6002a4 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf6002b4 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600404 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf60041c 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf600434 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf60043c 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600448 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf600460 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf600474 0x80 > $MEM_DUMP_PATH/register_config
    echo 0xf600500 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xf600530 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf600540 0x2c > $MEM_DUMP_PATH/register_config
    echo 0xf600570 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf600600 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf800000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf800008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf800054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8000f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf810000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf810008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf810054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8100f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf820000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf820008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf820054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8200f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf830000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf830008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf830054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8300f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf840000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf840008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf840054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8400f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf850000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf850008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf850054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8500f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf860000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf860008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf860054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8600f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf868000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf870000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf870008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf870054 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xf8700f0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xf878000 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf880000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf880008 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf880054 0x34 > $MEM_DUMP_PATH/register_config
    echo 0xf880098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8800a0 0x44 > $MEM_DUMP_PATH/register_config
    echo 0xf880140 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf8801b4 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf8801f0 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf8c0000 0x248 > $MEM_DUMP_PATH/register_config
    echo 0xf8c8000 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8008 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8010 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8018 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8020 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8028 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8038 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8048 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8058 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8060 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8068 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8078 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8088 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8090 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8098 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80a0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80a8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80b0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80b8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80c0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80c8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80d0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80d8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80e0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80e8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80f0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c80f8 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8108 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8110 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8c8118 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8cc000 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xf8cc030 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf8cc040 0x48 > $MEM_DUMP_PATH/register_config
    echo 0xf8cc090 0x88 > $MEM_DUMP_PATH/register_config
    echo 0xf900000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf900040 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf900400 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xf900900 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf900c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf900c0c 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf900c40 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf900fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xf901000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xf901040 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf901900 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xf901c00 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf901c0c 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xf901c40 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xf901fd0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa80000 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfa80040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa80080 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfa82000 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfa82040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa82080 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfa84000 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfa84040 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa84080 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfa90000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0xfa90080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfa90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa92000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0xfa92080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfa92100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfa94000 0x5c > $MEM_DUMP_PATH/register_config
    echo 0xfa94080 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfa94100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfaa0004 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfaa0028 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfaa0054 0x70 > $MEM_DUMP_PATH/register_config
    echo 0xfb00000 0x118 > $MEM_DUMP_PATH/register_config
    echo 0xfb70000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb70010 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb70090 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfb70100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70110 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb70190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb701a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb70220 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb702a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb70320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70390 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb70410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70420 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb704a0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb70520 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb70580 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb70600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70610 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70690 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70710 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70790 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70810 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70890 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70910 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70990 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70a10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70a90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70b90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70c10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70c90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70d10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb70d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb70d90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb70e10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb70e90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb70f10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb70f90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb71010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb71080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb71090 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71110 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71190 0x100 > $MEM_DUMP_PATH/register_config
    echo 0xfb71990 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71a10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71a80 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb71a90 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb71ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb71bb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb71c30 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb71d00 0x2c > $MEM_DUMP_PATH/register_config
    echo 0xfb78000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb78010 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb78090 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfb78100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78110 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb78190 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb781a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb78220 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb782a0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb78320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78380 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78390 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb78410 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78420 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb784a0 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfb78520 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb78580 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb78600 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78610 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78690 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78710 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78790 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78810 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78890 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78910 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78990 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78a10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78a90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78b00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78b90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78c10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78c90 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78d10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb78d80 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb78d90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb78e10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb78e90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb78f10 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb78f90 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb79010 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb79080 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb79090 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79110 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79190 0x100 > $MEM_DUMP_PATH/register_config
    echo 0xfb79990 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79a10 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79a80 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb79a90 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79b10 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfb79ba0 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb79bb0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfb79c30 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb79d00 0x2c > $MEM_DUMP_PATH/register_config
    echo 0xfb90000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb90020 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfb90050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb90070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb90080 0x64 > $MEM_DUMP_PATH/register_config
    echo 0xfb90100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb90120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb90140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb90200 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb90700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb9070c 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb90780 0x80 > $MEM_DUMP_PATH/register_config
    echo 0xfb90808 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfb90824 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfb90840 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfb93500 0xa0 > $MEM_DUMP_PATH/register_config
    echo 0xfb93a80 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfb93aa8 0xc8 > $MEM_DUMP_PATH/register_config
    echo 0xfb93c00 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfb93c24 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfba0000 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfba0020 0x14 > $MEM_DUMP_PATH/register_config
    echo 0xfba0050 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba0070 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba0080 0x64 > $MEM_DUMP_PATH/register_config
    echo 0xfba0100 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba0120 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba0140 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba0200 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfba0700 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfba070c 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfba0780 0x80 > $MEM_DUMP_PATH/register_config
    echo 0xfba0808 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfba0824 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfba0840 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfba0c48 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfba0c64 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfba0c80 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfba1088 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfba10a4 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfba10c0 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfba3500 0x1e0 > $MEM_DUMP_PATH/register_config
    echo 0xfba3a80 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfba3aa8 0xc8 > $MEM_DUMP_PATH/register_config
    echo 0xfba3c00 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfba3c24 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfc20000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfc21000 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfd80000 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfd800e4 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xfd80104 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd80140 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd80154 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd80170 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfd80178 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfd80200 0x460 > $MEM_DUMP_PATH/register_config
    echo 0xfd90000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd90014 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfd90058 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfd900b0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd900d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfd90100 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd90200 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd90300 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xfd90320 0x4  > $MEM_DUMP_PATH/register_config
    echo 0xfd90340 0x50 > $MEM_DUMP_PATH/register_config
    echo 0xfd903b0 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfd903e0 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfd90410 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfd91000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd91014 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfd91058 0x50 > $MEM_DUMP_PATH/register_config
    echo 0xfd910b0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd910d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfd91100 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd91200 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd91300 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xfd91320 0x18 > $MEM_DUMP_PATH/register_config
    echo 0xfd91340 0x50 > $MEM_DUMP_PATH/register_config
    echo 0xfd913b0 0x4c > $MEM_DUMP_PATH/register_config
    echo 0xfd91410 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfd92000 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd92014 0x3c > $MEM_DUMP_PATH/register_config
    echo 0xfd92058 0x40 > $MEM_DUMP_PATH/register_config
    echo 0xfd920b0 0x10 > $MEM_DUMP_PATH/register_config
    echo 0xfd920d0 0x24 > $MEM_DUMP_PATH/register_config
    echo 0xfd92100 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd92200 0x30 > $MEM_DUMP_PATH/register_config
    echo 0xfd92300 0x1c > $MEM_DUMP_PATH/register_config
    echo 0xfd92320 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfd92340 0x50 > $MEM_DUMP_PATH/register_config
    echo 0xfd923b0 0x20 > $MEM_DUMP_PATH/register_config
    echo 0xfd923e0 0xc > $MEM_DUMP_PATH/register_config
    echo 0xfd92410 0x8 > $MEM_DUMP_PATH/register_config
    echo 0xfd98000 0x90 > $MEM_DUMP_PATH/register_config
    echo 0xfd98100 0x70 > $MEM_DUMP_PATH/register_config
    echo 0xfd98170 0x8  > $MEM_DUMP_PATH/register_config
    echo 0x0FD00000 0x8000 > $MEM_DUMP_PATH/register_config
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
coresight_config=`getprop persist.debug.coresight.config`
srcenable="enable"
enable_debug()
{
    echo "blair debug"
    etr_size="0x2000000"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on blair."
    adjust_permission
    enable_stm_events
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing
    fi
    enable_core_hang_config
    enable_dcc
    enable_schedstats
    setprop ro.dbg.coresight.stm_cfg_done 1
    enable_cpuss_register
}

enable_debug
