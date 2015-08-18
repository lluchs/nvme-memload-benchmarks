#!/bin/bash

export NAME
export PATTERN
export LIMIT

NAME=single-write
PATTERN=single
LIMIT=-G500000
./run.sh

NAME=single-read
PATTERN="single -oread"
LIMIT=-G250000
./run.sh

NAME=random-write
PATTERN=random
LIMIT=-G100000
./run.sh

NAME=random-read
LIMIT=-G50000
PATTERN="random -oread"
./run.sh

NAME=flush
PATTERN=flush
LIMIT=-G350000
./run.sh

# Run noop with all available counters.
export COUNTERS='PCIeRdCur-hits PCIeRdCur-misses RFO-hits-filtered RFO-misses-filtered ItoM-hits-filtered ItoM-misses-filtered CRd-hits CRd-misses DRd-hits DRd-misses PRd-hits PRd-misses WiL-hits WiL-misses'
NAME=noop
PATTERN=noop
LIMIT=-t5
./run.sh
