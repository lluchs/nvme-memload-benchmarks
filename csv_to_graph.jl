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
	DataFrame(real = mean(df[:real]), user = mean(df[:user]), sys = mean(df[:sys]), count = length(df[1]))
end

writetable("$outdir/average.csv", averaged)

pl = plot(input, xgroup=:benchmark, x=:loadconfig, y=:real, color=:loadconfig, Geom.subplot_grid(Geom.point))
draw(SVGJS("$outdir/scatter.svg", 30cm, 15cm), pl)

pl = plot(input, xgroup=:benchmark, x=:loadconfig, y=:real, Geom.subplot_grid(Geom.violin))
draw(SVGJS("$outdir/violin.svg", 30cm, 15cm), pl)

pl = plot(averaged, x=:benchmark, color=:loadconfig, y=:real, Geom.bar(position=:dodge))
draw(SVGJS("$outdir/average.svg", 30cm, 15cm), pl)
