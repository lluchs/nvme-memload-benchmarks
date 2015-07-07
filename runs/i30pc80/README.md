# Benchmark runs

## benchmark1
 - -j1

## benchmark2
 - -j8
 - taskset: 1/7

## benchmark3
 - -j8 -c once
 - taskset: 1/7

## benchmark4
 - -j8 -c always
 - taskset: 1/7

## benchmark5
 - -j8
 - -b 262144 (= 1 GiB)
 - taskset: 1/7

## benchmark6
 - -j8
 - no pinning (7 Parsec threads)
