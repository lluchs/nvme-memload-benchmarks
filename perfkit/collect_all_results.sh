#!/bin/bash

# Automatically converts all results...

set -eu

for pc in i30pc74 i30pc80; do
    for benchmark in memtier-redis silo-tpcc silo-ycsb; do
	./collect_results.sh $benchmark runs/$pc/benchmark2 > runs/collected/$pc-$benchmark.csv
    done
done
