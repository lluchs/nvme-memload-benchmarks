#!/bin/bash

# First priority: check that we got power management settings right (no
# TurboBoost, Intel Pstate at max...)
source check_pstate.sh

# trap and kill jobs on exit
trap 'kill $(jobs -p)' EXIT
trap 'kill $(jobs -p)' ERR

WORKLOADS="blackscholes bodytrack canneal dedup ferret"
WORKLOADS+=" freqmine"
WORKLOADS+=" raytrace streamcluster swaptions vips x264"
# do not run netferret -- just takes too much time...
# do not run fluidanimate -- needs 2^n threads which would clash with
# DMA load generators
# do not run facesim -- does not wor k with 12 threads, either

# TODO re-evaluate netstreamcluster, did produce a lockup
# temporarily disabled netstreamcluster

# TODO re-evaluate netdedup, randomly produces oddly long runtimes
# temporarily disabled netdedup

#for i in $(seq 1 4); do
for i in $(seq 1 10); do
    # for conf in $(seq 1 7) ; do
    #for conf in 1 5 7 ; do
    for conf in 1 2 3 ; do
	for w in $WORKLOADS ; do
	    date
	    ./parsec.sh $conf $w
	done
    done
done

