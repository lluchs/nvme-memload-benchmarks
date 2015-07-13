#!/bin/bash

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source ../check_pstate.sh

THREADS=3
CPU_NODE=0
BENCHMARK_CPU_LIST=0-2
NVME_CPU_LIST=3

# trap and kill jobs on exit
trap 'sudo pkill -P $$' EXIT
trap 'sudo pkill -P $$' ERR

echo "🕑HEAD,real,user,sys,benchmark,threads,loadconfig"

declare -A ops_per_worker
ops_per_worker[tpcc]=10000000
ops_per_worker[ycsb]=1000000000
# Parameters: <benchmark: tpcc/ycsb> <loadconfig>
function run_silo {
    numactl -a --membind=$CPU_NODE --cpunodebind=$CPU_NODE \
	taskset -c $BENCHMARK_CPU_LIST \
	/usr/bin/time -f "🕑,%e,%U,%S,silo-$1,$THREADS,$2" \
	./benchmarks/silo/out-perf.masstree/benchmarks/dbtest \
	    --verbose --bench $1 --num-threads $THREADS \
	    --ops-per-worker ${ops_per_worker["$1"]}
}

function gen_load {
    local DIR=~/tools/nvme-memload
    sudo numactl -a --membind=$CPU_NODE --cpunodebind=$CPU_NODE \
	taskset -c $NVME_CPU_LIST \
	$DIR/nvme-memload -j4 $NVME_MEMLOAD_PARAMS /dev/nvme0n1 $@ &
    # Wait a bit to get to full speed.
    sleep 1
}

# configuration in $1
if [ -z $1 ] ; then
    echo "please specify benchmark configuration as parameter"
    exit -1
fi

if [ -z $2 ] ; then
    echo "please specify the workload as additional parameter"
    exit -1
fi

case $1 in
    1)
	echo config 1 - no concurrent DMA activity
	run_silo $2 plain
    ;;
    2)
	echo config 2 - random pattern
	gen_load random
	run_silo $2 random
    ;;
    3)
	echo config 3 - single pattern
	gen_load single
	run_silo $2 single
    ;;

    *)
	echo "please specify benchmark configuration as parameter"
	exit -1
    ;;
esac

