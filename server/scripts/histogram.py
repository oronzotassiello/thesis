#!/usr/bin/python

import sys
import numpy as np

f = open(sys.argv[1])
pos = int(sys.argv[2])-1
nbin = int(sys.argv[3])

v = []
for line in f:
    n = float(line.rstrip().split()[pos])
    v.append(n)

count, rbin = np.histogram(v, nbin)
print np.mean(v), np.std(v)
for i in range(nbin):
    print rbin[i], rbin[i+1], count[i]

