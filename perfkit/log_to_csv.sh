#!/bin/bash

# Assume all headers are the same. Print only the first one.
sed -n '/^🕑HEAD,/{s///;s/$/,runtime,agg_throughput/;p;q}' <&0
# Print all content rows.
sed -n '
/^runtime: \(.*\) sec$/ {
    s//,\1/
    h
}
/^agg_throughput: \(.*\) ops\/sec$/ {
    s//,\1/
    H
}
/^🕑,/ {
    G
    s///
    s/\n//g
    p
}
' <&0
