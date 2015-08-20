#!/usr/bin/gnuplot

set datafile separator tab
set xtics rotate
set logscale y
set grid

set xlabel "counter"

set style fill solid 0.25 border
set boxwidth 0.7 relative
plot "< grep noop all.tsv" using 0:6:xticlabels(1) lc rgb '#1f77b4' notitle with boxes
