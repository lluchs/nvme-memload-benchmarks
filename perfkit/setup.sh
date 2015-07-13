#!/bin/bash

mkdir -p benchmarks

[[ -d benchmarks/silo ]] || (
    git clone https://github.com/stephentu/silo.git benchmarks/silo
    cd benchmarks/silo
    git checkout cc11ca1ea949ef266ee12a9b1c310392519d9e3b
    make -j
    make -j dbtest
)
