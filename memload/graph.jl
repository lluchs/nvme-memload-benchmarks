#!/usr/bin/env julia

using DataFrames
using Cairo
using Gadfly

# Read CSV from command line argument.
df = readtable(ARGS[1])
# Output directory given by the second argument or inferred from
# input filename.
outdir = length(ARGS) == 2 ? ARGS[2] : splitext(ARGS[1])[1]
mkpath(outdir)

# Calculate bandwidth per second in MiB.
blocksize = 4096
commandsize = 64 + 16 # Submission queue + completion queue entries
df[:bandwidth] = map(row -> div(row[:blocks] * blocksize + row[:commands] * commandsize, row[:time]) >> 20, eachrow(df))
# Same for command rate per second.
df[:command_rate] = map(row -> div(row[:commands], row[:time]), eachrow(df))

yscale = Scale.y_continuous(format=:plain)
xticks = Guide.xticks(ticks=collect(1:reduce(max, df[:workers])))

pl = plot(df, x=:workers, y=:bandwidth, Guide.ylabel("bandwidth in MiB/s"), color=:pattern, Geom.line, xticks, yscale)
draw(PDF("$outdir/bandwidth.pdf", 15cm, 10cm), pl)

pl = plot(df, x=:workers, y=:command_rate, Guide.ylabel("commands per second"), color=:pattern, Geom.line, xticks)
draw(PDF("$outdir/command_rate.pdf", 15cm, 10cm), pl)
