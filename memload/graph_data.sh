#!/bin/bash

: ${BLOCKSIZE:=4096}

# What to graph?
case $1 in
blocks) # blocks in MiB
	data='rshift($4 * '$BLOCKSIZE', 20) / $1'
	;;
bandwidth) # blocks + commands in MiB
	data='rshift($4 * '$BLOCKSIZE' + $5 * (64 + 16), 20) / $1'
	;;
*)
	echo "Usage: $0 <what to graph>"
	exit 1
esac

awk '
NR > 1 { d[$2][$3] = '"$data"'; }
END {
	for (w in d) {
		printf "workers ";
		for (pattern in d[w]) { printf "%s ", pattern; }
		printf "\n";
		break;
	}
	for (w in d) {
		printf "%d ", w;
		for (pattern in d[w]) { printf "%d ", d[w][pattern]; }
		printf "\n";
	}
}
' <&0
