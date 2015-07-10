# Benchmark runs 2

In the previous benchmarks, Parsec has sometimes overwritten the pinning.
`nvme-memload` is pinned to the last CPU here to prevent this.

## benchmark1
 - -j4
 - taskset: 1/3

## benchmark2
 - -j4 -c once
 - taskset: 1/3

## benchmark3
 - -j4 -c always
 - taskset: 1/3

## benchmark4
 - -j4
 - -b 262144 (= 1 GiB)
 - taskset: 1/3
