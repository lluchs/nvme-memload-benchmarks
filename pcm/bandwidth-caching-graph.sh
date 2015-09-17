#!/bin/bash

echo counter pattern bufsize caching hits misses

awk -F "\t" '
/-hits/ { hits = $8; }
# Assume both runs have the same configuration.
/-misses/ {
	split($1, a, "-"); counter = a[1];
	pattern = $3; bufsize = $4; caching = $5; misses = $8;

	print counter, pattern, bufsize, caching, hits, misses;
}
' <&0
