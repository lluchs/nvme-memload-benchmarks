#!/bin/sh
#
# fix CPU frequency to maximum frequency to avoid
# noise in experiments
# ... for intel-pstate driver (SandyBridge and newer...)

DIR=/sys/devices/system/cpu/intel_pstate

echo 100 > $DIR/min_perf_pct
echo 100 > $DIR/max_perf_pct
echo 1 > $DIR/no_turbo

for i in /sys/devices/system/cpu/cpu[0-9]*; do
    echo performance > $i/cpufreq/scaling_governor
done

# apparently, no_turbo gets disabled by setting governor?!
echo 1 > $DIR/no_turbo

