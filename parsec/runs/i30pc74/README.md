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

## benchmark7
 - -j4
 - no pinning (3 Parsec threads)

## benchmark8
 - -j4 -l 90000 (½ single bandwidth)
 - taskset: 1/3
