#!/usr/bin/gnuplot

reset

set key autotitle columnheader
set grid

set xlabel "workers"
set ylabel "bandwidth in MiB/s"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"
set linetype 3 lc rgb "#2ca02c"
set linetype 4 lc rgb "#d62728"
set linetype 5 lc rgb "#9467bd"

# plot for [COL=2:6] "< cat runs/i30pc74/benchmark2.tsv | ./graph_data.sh bandwidth" using 1:COL lw 2 with lines
plot for [COL=2:5] "< cat runs/i30pc74/benchmark3.tsv | BLOCKSIZE=512 ./graph_data.sh blocks" using 1:COL lw 2 with lines
