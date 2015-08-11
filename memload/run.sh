#!/bin/bash

set -eu

duration=10
max_parallelism=8
lba_format=3

memload() {
	local p=$(cut -d- -f1 <(echo $pattern))
	local o=$(cut -d- -f2 <(echo $pattern))
	sudo $(which nvme-memload) -t$duration $opts /dev/nvme0n1 $p -o$o
}

analyze() {
	awk '
		/blocks\/s/ { blocks += $1; commands += $6; }
		END {
			OFS = "\t";
			print "'"🕑\t$duration\t$j\t$pattern"'", blocks, commands;
		}
	'
}

echo "🕑	time	workers	pattern	blocks	commands"

for j in $(seq 1 $max_parallelism); do
	for pattern in single-read single-write random-read random-write flush; do
		sudo nvme format /dev/nvme0n1 -l$lba_format
		opts="-j$j" memload | tee >(analyze)
	done
done
