#!/bin/bash

# Converts the parsec log (with /usr/bin/time) to TSV for analysis.

echo "name	user	system	elapsed	CPU"
# Get benchmark name and timing data.
sed -n '
s/\[PARSEC\] \[========== Running benchmark \(.*\) ==========\]/\1/p
s/^\([0-9.]*\)user \([0-9.]*\)system \([0-9:.]*\)elapsed \([0-9]*\)%CPU.*/\1\t\2\t\3\t\4/p
' $1 |
# Join line pairs.
paste - -
