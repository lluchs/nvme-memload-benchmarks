#!/bin/bash

mkdir -p benchmarks

[[ -d benchmarks/silo ]] || (
    git clone https://github.com/stephentu/silo.git benchmarks/silo
    cd benchmarks/silo
    git checkout cc11ca1ea949ef266ee12a9b1c310392519d9e3b
    make -j
    make -j dbtest
)

[[ -d benchmarks/memtier_benchmark ]] || (
    git clone https://github.com/RedisLabs/memtier_benchmark benchmarks/memtier_benchmark
    cd benchmarks/memtier_benchmark
    git checkout 1.2.4

    sudo apt-get install libevent-dev autoconf redis-server
    sudo systemctl stop redis-server

    autoreconf -ivf
    ./configure
    make -j
)
