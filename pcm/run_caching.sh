#!/bin/bash

export NAME
export PATTERN
export LIMIT
export COUNTERS


run() {
	# write => ItoM
	COUNTERS='ItoM-hits-filtered ItoM-misses-filtered'

	NAME=single-write
	PATTERN="single $1"
	LIMIT="-G500000 $2"
	./run.sh

	NAME=random-write
	PATTERN="random $1"
	LIMIT="-G100000 $2"
	./run.sh

	# read => PCIeRdCur
	COUNTERS='PCIeRdCur-hits PCIeRdCur-misses'

	NAME=single-read
	PATTERN="single -oread $1"
	LIMIT="-G250000 $2"
	./run.sh

	NAME=random-read
	PATTERN="random -oread $1"
	LIMIT="-G50000 $2"
	./run.sh
}

run "" ""
run "" -conce
run -b262144 ""
run -b262144 -calways

