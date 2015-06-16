#!/bin/bash

# Runs the Parsec benchmark in parallel with different nvme-memload settings.

# Parsec directory
PARSECDIR=~/parsec-3.0
. $PARSECDIR/env.sh
PARSEC_INPUT=test
PARSEC_CONFIG=gcc
PARSEC_N=4

# nvme-memload directory
NVME_MEMLOAD=~/tools/nvme-memload
CONFIGURATIONS=(
  "plain"
  "full.so -b 100000 -o write"
)

# SSD NVMe device and block format
SSD=/dev/nvme0n1
SSD_FORMAT=3

set -eu

run_nvme_memload() {
  echo "Formatting $SSD"
  sudo nvme format $SSD -l $SSD_FORMAT
  sudo $NVME_MEMLOAD/nvme-memload $SSD "$NVME_MEMLOAD/patterns/$@" &
}

run_parsec() {
  parsecmgmt -a run -p parsec -i $PARSEC_INPUT -c $PARSEC_CONFIG -s /usr/bin/time -n $PARSEC_N
}

for config in "${CONFIGURATIONS[@]}"
do
  echo "Running configuration $config"
  pid=
  if [[ $config != "plain" ]]; then 
    run_nvme_memload $config
    pid=$!
    echo "nvme-memload running ($pid), waiting a bit to get up to speed..."
    sleep 5
  fi
  run_parsec
  [[ -n $pid ]] && sudo kill $pid
done
