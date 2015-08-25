#!/usr/bin/gnuplot

reset

set key autotitle columnheader
set xtics rotate
set yrange [0:]
set grid

set xlabel "pattern and event"
set ylabel "counter value"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"
set linetype 3 lc rgb "#2ca02c"

set style fill solid 0.25 border
set style data histograms
set style histogram rowstacked
set boxwidth 0.9 relative
plot for [COL=3:5] "< cat all.tsv | grep -v noop | ./bandwidth-graph.sh" using COL:xticlabels(column(5) < 0 ? stringcolumn(2) . ": " . stringcolumn(1) : "")
