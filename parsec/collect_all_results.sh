#!/bin/bash

# Automatically converts all results...

set -eu

for pc in i30pc74 i30pc80; do
    for benchmark in canneal raytrace streamcluster; do
	./collect_results.sh $benchmark runs2/$pc > runs2/collected/$pc-$benchmark.csv
    done
done
