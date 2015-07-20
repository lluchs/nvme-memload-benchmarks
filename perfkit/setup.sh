#!/bin/bash

mkdir -p benchmarks

[[ -d benchmarks/silo ]] || (
    git clone https://github.com/stephentu/silo.git benchmarks/silo
    cd benchmarks/silo
    git checkout cc11ca1ea949ef266ee12a9b1c310392519d9e3b

    sudo apt-get install -y libjemalloc-dev libdb5.3++-dev libmysqld-dev libaio-dev libssl-dev

    make -j
    make -j dbtest
)

[[ -d benchmarks/memtier_benchmark ]] || (
    git clone https://github.com/RedisLabs/memtier_benchmark benchmarks/memtier_benchmark
    cd benchmarks/memtier_benchmark
    git checkout 1.2.4

    sudo apt-get install -y libevent-dev autoconf redis-server zlib1g-dev
    sudo systemctl stop redis-server
    sudo systemctl disable redis-server

    autoreconf -ivf
    ./configure
    make -j
)
