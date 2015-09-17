#!/usr/bin/gnuplot

reset

set terminal pdfcairo size 15cm,10cm
set output "graphs/noop.pdf"


set key autotitle columnheader
set xtics rotate
set logscale y
set grid

# set xlabel "counter"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"

set style fill solid 0.25 border
set style data histograms
set style histogram clustered gap 1
set boxwidth 0.9 relative
plot for [COL=2:3] "< cat data/all.tsv | ./noop.sh" using COL:xticlabels(1)
