#!/usr/bin/gnuplot

reset
set terminal pdfcairo fontscale 0.9 size 13cm,11cm

set key box
set key autotitle columnheader
set grid

set xlabel "workers"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"
set linetype 3 lc rgb "#2ca02c"
set linetype 4 lc rgb "#d62728"
set linetype 5 lc rgb "#9467bd"

set key font    ",11"
set tics font   ",11"
set xlabel font ",11"
set ylabel font ",11"

# Bandwidth graphs
set ylabel "bandwidth in MiB/s"

set output "i30pc74-bandwidth.pdf"
set key at 7.8, 1300 right top
plot for [COL=2:6] "< cat runs/i30pc74/benchmark1.tsv | ./graph_data.sh bandwidth" using 1:COL lw 2 with lines
set output "i30pc80-bandwidth.pdf"
set key at 7.8, 2700 right top
plot for [COL=2:6] "< cat runs/i30pc80/benchmark1.tsv | ./graph_data.sh bandwidth" using 1:COL lw 2 with lines

set output "i30pc74-bandwidth-512.pdf"
plot for [COL=2:5] "< cat runs/i30pc74/benchmark3.tsv | BLOCKSIZE=512 ./graph_data.sh bandwidth" using 1:COL lw 2 with lines
set output "i30pc80-bandwidth-512.pdf"
plot for [COL=2:5] "< cat runs/i30pc80/benchmark3.tsv | BLOCKSIZE=512 ./graph_data.sh bandwidth" using 1:COL lw 2 with lines


# Command rate graphs
set ylabel "1000 commands per second"

set output "i30pc74-command_rate.pdf"
set key inside left top
plot for [COL=2:6] "< cat runs/i30pc74/benchmark1.tsv | ./graph_data.sh command-rate" using 1:COL lw 2 with lines
set output "i30pc74-command_rate-batched.pdf"
plot for [COL=2:6] "< cat runs/i30pc74/benchmark2.tsv | ./graph_data.sh command-rate" using 1:COL lw 2 with lines
set output "i30pc80-command_rate.pdf"
set key at 7.8,500 right top
plot for [COL=2:6] "< cat runs/i30pc80/benchmark1.tsv | ./graph_data.sh command-rate" using 1:COL lw 2 with lines
