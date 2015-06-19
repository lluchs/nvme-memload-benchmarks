#!/usr/bin/env python

# Turned out extremely helpful: pythex.org
# online / live regular expression editor and debugger
#
# txt2re.com: Build regex from string
# https://www.debuggex.com/
# http://www.pyregex.com/

import re
import sys
import textwrap

sample = """\
[PARSEC] Benchmarks to run:  parsec.x264

[PARSEC] [========== Running benchmark parsec.x264 [1] ==========]
[PARSEC] Deleting old run directory.
[PARSEC] Setting up run directory.
[PARSEC] Unpacking benchmark input 'native'.
eledream_1920x1080_512.y4m
[PARSEC] Running 'time /home/mhillen/parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc/bin/x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 16 -o eledream.264 eledream_1920x1080_512.y4m':
[PARSEC] [---------- Beginning of output ----------]
PARSEC Benchmark Suite Version 3.0-beta-20150206
yuv4mpeg: 1920x1080@25/1fps, 0:0

encoded 512 frames, 50.87 fps, 29709.42 kb/s

real	0m10.094s
user	2m2.676s
sys	0m1.536s
[PARSEC] [----------    End of output    ----------]
[PARSEC]
[PARSEC] BIBLIOGRAPHY
[PARSEC]
"""

argstring = ""
for s in sys.argv[1:]:
    argstring += ", " + s

data = ""
for l in sys.stdin.readlines():
    data += l
    print l,

# highly inspired by Michael Taenzer's code
resultre = re.compile(
	textwrap.dedent( """\
	\[PARSEC\] \[---------- Beginning of output ----------\]
	(?P<misc>.*)
	real\s*(?P<real>\d+m\d+\.\d+s)
	user\s*(?P<user>\d+m\d+\.\d+s)
	sys\s*(?P<sys>\d+m\d+\.\d+s)
	\[PARSEC\] \[----------    End of output    ----------\]
	"""
	), re.DOTALL
)

timere = re.compile( "(?P<mins>\d+)m(?P<secs>\d+\.\d+)s" )

def parsetime(timestr):
    match = timere.match(timestr)
    mins = match.group("mins")
    secs = match.group("secs")

    mins = int(mins)
    secs = float(secs)
    return (mins * 60.0) + secs

matches = resultre.search( data )

# check for time output
if matches:
    real = parsetime( matches.group("real") )
    user = parsetime( matches.group("user") )
    systime = parsetime( matches.group("sys") )

    print "RESULTS, ", real, ",", user, ",", systime, argstring

perfre = re.compile("(\d+),PERF,,PERF,((?:[a-z][a-z]*[0-9]+[a-z0-9]*))")

matches = perfre.findall( data )
perfresults = {}

for res in matches:
    count, event = res
    perfresults[event] = count

if len(matches) > 0:
    print "PERFHEADER, UNHALTED_CORE_CYLCES, INSTRUCTION_RETIRED,",
    print "MEM_UOPS_RETIRED_ALL_STORES, MEM_UOPS_RETIRED_ALL_LOADS,",
    print "LLC_MISSES, workload, threads, numa_node"

    print "PERFRES",
    for event in ['r51003c', 'r5100c0', 'r5182d0', 'r5181d0', 'r51412e']:
        print ",", perfresults[event],
    print argstring

