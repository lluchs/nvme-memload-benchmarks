#!/usr/bin/gnuplot

set datafile separator tab
set key autotitle columnheader
set xtics rotate
set yrange [0:]
set grid

set xlabel "pattern"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"

set style fill solid 0.25 border
set style data histograms
set style histogram clustered gap 2
set boxwidth 0.9 relative
plot for [COL=5:6] "< grep -E 'pattern|RFO-hits' all.tsv | grep -v noop" using COL:xticlabels(3)