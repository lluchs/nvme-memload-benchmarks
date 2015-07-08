#!/bin/bash

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source check_pstate.sh

THREADS=3
CPU_NODE=0
PARSEC_CPU_LIST=0-2
NVME_CPU_LIST=3
INPUT=native
# INPUT=simsmall

# trap and kill jobs on exit
trap 'sudo pkill -P $$' EXIT
trap 'sudo pkill -P $$' ERR

echo "🕑HEAD,real,user,sys,benchmark,threads,loadconfig"
# run Parsec benchmarks with DMA load in background
# param: benchmark, NUMA node, config (as passed parameter)
function run_parsec {
    numactl -a --membind=$CPU_NODE --cpunodebind=$CPU_NODE \
	taskset -c $PARSEC_CPU_LIST \
	parsecmgmt -a run -p $1 -i $INPUT -n $THREADS \
	-s "/usr/bin/time -f '🕑,%e,%U,%S,$1,$THREADS,$2'"
}

function gen_load {
    local DIR=~/tools/nvme-memload
    sudo numactl -a --membind=$CPU_NODE --cpunodebind=$CPU_NODE \
	taskset -c $NVME_CPU_LIST \
	$DIR/nvme-memload -j4 /dev/nvme0n1 $DIR/patterns/$@ &
    # Wait a bit to get to full speed.
    sleep 1
}

# configuration in $1
if [ -z $1 ] ; then
    echo "please specify benchmark configuration as parameter"
    exit -1
fi

if [ -z $2 ] ; then
    echo "please specify the Parsec workload as additional parameter"
    exit -1
fi

case $1 in
    1)
	echo config 1 - no concurrent DMA activity
	run_parsec $2 plain
    ;;
    2)
	echo config 2 - random pattern
	gen_load random.so
	run_parsec $2 random
    ;;
    3)
	echo config 3 - single pattern
	gen_load single.so
	run_parsec $2 single
    ;;

    *)
	echo "please specify benchmark configuration as parameter"
	exit -1
    ;;
esac

