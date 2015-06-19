#!/bin/bash

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source check_pstate.sh

THREADS=14

# trap and kill jobs on exit
trap 'kill $(jobs -p)' EXIT
trap 'kill $(jobs -p)' ERR

echo "HEADER, real, user, sys, benchmark, threads, NUMAdomain, loadconfig"
# run Parsec benchmarks with DMA load in background
# param: benchmark, NUMA node, config (as passed parameter)
function run_parsec {
    numactl -a --membind=$2 --cpunodebind=$2 \
	parsecmgmt -a run -p $1 -i native -n $THREADS \
	| ./parse-parsec-output.py $1 $THREADS $2 $3
}

function gen_load {
    ./gen_load.sh &
}

function kill_load {
    kill $(jobs -p)
}


# configuration in $1
if [ -z $1 ] ; then
    echo "please specify benchmark configuration (1-7) as parameter"
    exit -1
fi

if [ -z $2 ] ; then
    echo "please specify the Parsec workload as additional parameter"
    exit -1
fi

case $1 in
    1)
	echo config 1 - on NUMA node 0, no concurrent DMA activity
	run_parsec $2 0 1
    ;;
    2)
	echo config 2 - on NUMA node 0, concurrent DMA activity
	gen_load
	run_parsec $2 0 2
	kill_load

    ;;
    3)
	echo config 3 - on NUMA node 1, with concurrent DMA activity on 0
	gen_load
	run_parsec $2 1 3
	kill_load
    ;;

    4)
	echo config 4 - on NUMA node 1, no concurrent DMA activity
	run_parsec $2 1 4
    ;;

5)
	echo config 5 - on NUMA node 0, concurrent RDMA traffic
	./rdma-load.sh & sleep 1
	run_parsec $2 0 5
	kill_load
    ;;

    6)
	echo config 6 - on NUMA node 0, concurrent RDMA + local DMA
	./rdma-load.sh & sleep 1
	gen_load
	run_parsec $2 0 6
	kill_load
    ;;

    7)
	echo config 7 - on NUMA node 1, concurrent RDMA traffic
	./rdma-load.sh & sleep 1
	run_parsec $2 1 7
	kill_load
    ;;


    *)
	echo "please specify benchmark configuration (1-4) as parameter"
	exit -1
    ;;
esac

