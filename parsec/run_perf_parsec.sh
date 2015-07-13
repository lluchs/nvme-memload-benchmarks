#!/bin/bash

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source check_pstate.sh

# trap and kill jobs on exit
trap 'kill $(jobs -p)' EXIT
trap 'kill $(jobs -p)' ERR

WORKLOADS="blackscholes bodytrack canneal dedup ferret"
WORKLOADS+=" freqmine fluidanimate facesim"
WORKLOADS+=" raytrace streamcluster swaptions vips x264"
WORKLOADS+=" netferret netstreamcluster netdedup"

THREADS=1
NUMANODE=0

PERF_USER="time perf stat -e r51003c -e r5100c0 -e r5182d0 -e r5181d0 -e r51412e -x ,PERF,"
PERF_KERNEL="time perf stat -a -e r51003c -e r5100c0 -e r5182d0 -e r5181d0 -e r51412e -x ,PERF,"

#for i in $(seq 1 4); do
for w in $WORKLOADS ; do
    date
    numactl -a --membind=$NUMANODE --cpunodebind=$NUMANODE \
	parsecmgmt -a run -p $w -n $THREADS -i native \
	-s "$PERF_USER" \
	| ./parse-parsec-output.py $w $THREADS $NUMANODE

    sync
    sleep 3
    echo "\n\n"

done
#done

