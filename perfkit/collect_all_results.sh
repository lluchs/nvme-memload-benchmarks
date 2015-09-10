#!/bin/bash

# Automatically converts all results...

set -eu

pc=i30pc80
for benchmark in memtier-redis silo-tpcc silo-ycsb; do
    ./collect_results.sh $benchmark runs/$pc/benchmark2 runs/i30pc80/benchmark3 > runs/collected/$pc-$benchmark.csv
done

pc=i30pc74
for benchmark in memtier-redis silo-tpcc silo-ycsb; do
    ./collect_results.sh $benchmark runs/$pc/benchmark2a runs/i30pc74/benchmark3a > runs/collected/$pc-$benchmark.csv
done
