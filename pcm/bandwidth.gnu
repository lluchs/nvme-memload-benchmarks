#!/usr/bin/gnuplot

reset

set terminal pdfcairo size 20cm,15cm


set key autotitle columnheader
set xtics rotate
set yrange [0:]
set grid

# set xlabel "pattern and event"
# set ylabel "counter value"

set linetype 1 lc rgb "#1f77b4"
set linetype 2 lc rgb "#ff7f0e"
set linetype 3 lc rgb "#2ca02c"

set key font ",15"
set tics font ",15"
set style fill solid 0.25 border
set style data histogram
set style histogram clustered title font ",14" offset 0,-2 boxed gap 1
set boxwidth 0.9 relative
set bmargin 16

set macros
xticks='xticlabels(stringcolumn(2) . ": " . stringcolumn(1))'
cmd(mode)="< cat runs/caching.tsv | ./bandwidth-caching-graph.sh | grep -E 'counter|" . mode . "'"

set output "graphs/caching.pdf"
plot newhistogram "small buffer"                 lt 1, for [COL=5:6] cmd("small none")   using COL:@xticks, \
     newhistogram "small buffer, caching once"   lt 1, for [COL=5:6] cmd("small once")   using COL:@xticks notitle, \
     newhistogram "large buffer"                 lt 1, for [COL=5:6] cmd("large none")   using COL:@xticks notitle, \
     newhistogram "large buffer, caching always" lt 1, for [COL=5:6] cmd("large always") using COL:@xticks notitle
