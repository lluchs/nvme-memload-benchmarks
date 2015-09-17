#!/bin/bash

echo counter hits misses

grep noop <&0 | awk '
/-hits/ { hits = $6; }
# Assume both runs have the same configuration.
/-misses/ {
	split($1, a, "-"); counter = a[1];
	misses = $6;

	print counter, hits, misses;
}
'
