#!/bin/bash

export PATTERN
export LIMIT

PATTERN=single
LIMIT=-G500000
./run.sh

PATTERN=random
LIMIT=-G100000
./run.sh

PATTERN=flush
LIMIT=-G350000
./run.sh

PATTERN=noop
LIMIT=-t5
./run.sh
