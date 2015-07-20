#!/bin/bash

set -eu

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source ../check_pstate.sh

# trap and kill jobs on exit
trap 'pkill -P $$' EXIT
trap 'pkill -P $$' ERR

BENCHMARKS="tpcc ycsb memtier-redis"

for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in $BENCHMARKS ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

echo ★★★ Run 2: -b 262144 ★★★
export NVME_MEMLOAD_PARAMS=""
export NVME_MEMLOAD_PATTERN_PARAMS="-b 262144"
for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in $BENCHMARKS ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

echo ★★★ Run 3: -c always , -b 262144  ★★★
export NVME_MEMLOAD_PARAMS="-c always"
export NVME_MEMLOAD_PATTERN_PARAMS="-b 262144"
for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in $BENCHMARKS ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

