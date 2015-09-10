#!/bin/bash

# The benchmarks were run per configuration, but for the thesis, we want to show
# a single benchmark program's result across the different configurations. This
# script accepts a benchark name and will filter the results accordingly.

set -eu

BENCHMARK=${1:?Benchmark name needed as first parameter}
BASEPATH=${2:?Base path needed as second parameter}

# Print header
head -n1 $BASEPATH/benchmark1.csv

process() {
    sed -n "s/$BENCHMARK/$2/p" $1
}

process $BASEPATH/benchmark1.csv "default"
process $BASEPATH/benchmark3.csv "caching"
process $BASEPATH/benchmark4.csv "big buffer"
process $BASEPATH/benchmark5.csv "single channel"
