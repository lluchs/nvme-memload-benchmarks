#!/bin/bash

# Assume all headers are the same. Print only the first one.
sed -n '/^🕑HEAD,/{s///;s/$/,runtime,throughput/;p;q}' <&0
# Print all content rows.
sed -n '
# Data reported by the silo benchmarks.
/^runtime: \(.*\) sec$/ {
    s//,\1/
    h
}
/^agg_throughput: \(.*\) ops\/sec$/ {
    s//,\1/
    H
}

# Data reported by the memtier benchmark.
/.*\[RUN #1 100%,\s*\(\S*\) secs\].*/ {
    s//,\1/
    h
}
/^Totals    \(\S*\) .*$/ {
    s//,\1/
    H
}

# Benchmark done, print the timing row.
/^🕑,/ {
    G
    s///
    s/\n//g
    p
}
' <&0
