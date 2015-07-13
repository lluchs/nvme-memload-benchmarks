#!/bin/bash

set -eu

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source ../check_pstate.sh

# trap and kill jobs on exit
trap 'pkill -P $$' EXIT
trap 'pkill -P $$' ERR

for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in ycsb tpcc ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

echo ★★★ Run 2: -c once ★★★
export NVME_MEMLOAD_PARAMS="-c once"
for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in ycsb tpcc ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

echo ★★★ Run 3: -c always ★★★
export NVME_MEMLOAD_PARAMS="-c always"
for i in $(seq 1 5); do
    for conf in 1 2 3 ; do
	for w in ycsb tpcc ; do
	    date
	    ./run.sh $conf $w
	done
    done
done

