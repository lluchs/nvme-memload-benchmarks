#!/bin/bash

echo counter pattern hits misses expected

awk -F "\t" '
/-hits/ { hits = $6; }
# Assume both runs have the same amount of blocks/commands.
/-misses/ {
	split($1, a, "-"); counter = a[1];
	pattern = $3; blocks = $4; commands = $5; misses = $6;
	split(pattern, a, "-"); rw = a[2];
	if (counter == "PCIeRdCur") {
		expected = ((rw == "read" ? blocks * 4096 : 0) + commands * 64) / 64;
	} else if (counter == "ItoM") {
		expected = (rw == "write" ? blocks * 4096 : 0) / 64;
	} else {
		expected = 0;
	}

	# Print separate rows to allow comparison.
	if (0) {
		print counter, pattern, hits, misses, expected;
	} else {
		# -1 prevents a small line on top.
		print counter, pattern, hits, misses, -1;
		print counter "-ex", pattern, 0, 0, expected;
	}
}
' <&0
