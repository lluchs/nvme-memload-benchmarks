#!/bin/bash

# Optional parameter
${COUNTERS:='PCIeRdCur-hits PCIeRdCur-misses RFO-hits-filtered RFO-misses-filtered ItoM-hits-filtered ItoM-misses-filtered'}

# Required parameters
${NAME:?}
${PATTERN:?}
${LIMIT:?}

sudo nvme format /dev/nvme0n1 -l3

for counter in $COUNTERS; do
	echo "→ $counter with $NAME"
	sudo LD_LIBRARY_PATH=. $(which nvme-memload) -p$counter $LIMIT /dev/nvme0n1 $PATTERN
done
