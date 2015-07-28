#!/bin/bash

echo 'counter	time	pattern	blocks_total	cmds_total	pcm_total'

awk '
/^→/ { counter = $2; pattern = $4; blocks_total = 0; cmds_total = 0; }
/blocks\/s/ { blocks_total += $1; cmds_total += $6; }
/over/ { print counter "\t" $4 "\t" pattern "\t" blocks_total "\t" cmds_total "\t" $2; }
' <&0
