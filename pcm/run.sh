#!/bin/bash

COUNTERS='PCIeRdCur-hits PCIeRdCur-misses RFO-hits-filtered RFO-misses-filtered ItoM-hits-filtered ItoM-misses-filtered'
PATTERN=single

for counter in $COUNTERS; do
	echo "→ $counter with $PATTERN"
	sudo LD_LIBRARY_PATH=. $(which nvme-memload) -p$counter -t5 /dev/nvme0n1 $PATTERN
done
