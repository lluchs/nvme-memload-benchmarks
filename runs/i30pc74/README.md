# Benchmark runs

## benchmark1
 - HyperThreading
 - -j1

## benchmark2
 - HyperThreading
 - -j4

## benchmark3
 - -j4
 - taskset: 1/3

## benchmark4
 - -j4 -c once
 - taskset: 1/3

## benchmark5
 - -j4 -c always
 - taskset: 1/3

## benchmark6
 - -j4
 - -b 262144 (= 1 GiB)
 - taskset: 1/3
