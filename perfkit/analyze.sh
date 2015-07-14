#!/bin/bash

set -eu

logfile=$1
basename=$(basename $logfile .log)

# Split separate runs from the logfile.
csplit -f /tmp/$basename- $logfile /^★★★/ '{*}'

for f in /tmp/$basename-*; do
    target=$(dirname $logfile)/$(basename $f).csv
    cat $f | ../log_to_csv.sh > $target
    ./csv_to_graph.jl $target &
done

wait

rm /tmp/$basename-*
