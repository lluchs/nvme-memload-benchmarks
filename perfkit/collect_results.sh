#!/bin/bash

# The benchmarks were run per configuration, but for the thesis, we want to show
# a single benchmark program's result across the different configurations. This
# script accepts a benchark name and will filter the results accordingly.

set -eu

BENCHMARK=${1:?Benchmark name needed as first parameter}
BASEPATH=${2:?Base path needed as second parameter}

# Print header
head -n1 $BASEPATH-00.csv

process() {
    sed -n "s/$BENCHMARK/$2/p" $1
}

process $BASEPATH-00.csv "default"
process $BASEPATH-01.csv "big buffer"
process $BASEPATH-02.csv "caching"
