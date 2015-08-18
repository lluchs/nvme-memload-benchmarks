#!/bin/bash

COUNTERS='PCIeRdCur-hits PCIeRdCur-misses RFO-hits-filtered RFO-misses-filtered ItoM-hits-filtered ItoM-misses-filtered'
#PATTERN=flush
#LIMIT=-t5

for counter in $COUNTERS; do
	echo "→ $counter with $PATTERN"
	sudo LD_LIBRARY_PATH=. $(which nvme-memload) -p$counter $LIMIT /dev/nvme0n1 $PATTERN
done
