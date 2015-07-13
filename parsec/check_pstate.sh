#!/bin/bash
#
# check that intel_pstate driver for CPU frequency control is set to maximum settings to avoid
# noise in experiments
# ... for intel-pstate driver (SandyBridge and newer...)

function distress_msg {
	echo "Power Management settings are not right!"
	echo "Check Turbo Boost and Intel Pstate settings"
	echo "to avoid measurement noise."
}

DIR=/sys/devices/system/cpu/intel_pstate

MIN_PERF_PCT=$(cat $DIR/min_perf_pct)

if [[ $MIN_PERF_PCT != 100 ]] ; then
	distress_msg
	echo "min_perf_pct should be set to 100, but it is $MIN_PERF_PCT"
	exit -1
fi

MAX_PERF_PCT=$(cat $DIR/max_perf_pct)

if [[ $MAX_PERF_PCT != 100 ]] ; then
	distress_msg
	echo "max_perf_pct should be set to 100, but it is $MAX_PERF_PCT"
	exit -1
fi
	
NO_TURBO=$(cat $DIR/no_turbo)

if [[ $NO_TURBO != 1 ]] ; then
	distress_msg
	echo "Turbo Boost is still active (not disabled). You are asking for skewed results."
	exit -1
fi

for i in /sys/devices/system/cpu/cpu[0-9]*; do
	GOV=$(cat $i/cpufreq/scaling_governor)
	if [[ $GOV != performance ]] ; then
		distress_msg
		echo "scaling_governor for CPU $i set to $GOV, but it should be \"performance\""
		exit -1
	fi
done

