#!/bin/bash

echo 'counter	time	pattern	bufsize	caching	blocks_total	cmds_total	pcm_total'

awk '
BEGIN { OFS="\t"; }
/^→/ { counter = $2; pattern = $4; blocks_total = 0; cmds_total = 0; caching = "none"; }
/^Caching mode/ { caching = $3; }
/^Memory buffer size/ { bufsize = $4 > 1000 ? "large" : "small"; }
/blocks\/s/ { blocks_total += $1; cmds_total += $6; }
/over/ { print counter, $4, pattern, bufsize, caching, blocks_total, cmds_total, $2; }
' <&0
