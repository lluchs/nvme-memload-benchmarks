# Benchmark runs 2

In the previous benchmarks, Parsec has sometimes overwritten the pinning.
`nvme-memload` is pinned to the last CPU here to prevent this.

## benchmark1
 - -j8
 - taskset: 1/7

## benchmark2
 - -j8 -c once
 - taskset: 1/7

## benchmark3
 - -j8 -c always
 - taskset: 1/7

## benchmark4
 - -j8
 - -b 262144 (= 1 GiB)
 - taskset: 1/7
