#!/usr/bin/env julia

using DataFrames
using Gadfly

# Read CSV from command line argument.
input = readtable(ARGS[1])
# Output directory given by the second argument or inferred from
# input filename.
outdir = length(ARGS) == 2 ? ARGS[2] : splitext(ARGS[1])[1]
mkpath(outdir)

# Compute averages from multiple runs.
averaged = by(input, [:benchmark, :loadconfig]) do df
	DataFrame(real = mean(df[:real]), user = mean(df[:user]), sys = mean(df[:sys]))
end

writetable("$outdir/averaged.csv", averaged)

# Draw a ploc containing absolute times.
fullplot = plot(averaged, xgroup=:benchmark, x=:loadconfig, y=:real, Geom.subplot_grid(Geom.bar))
draw(SVGJS("$outdir/fullplot.svg", 30cm, 15cm), fullplot)
