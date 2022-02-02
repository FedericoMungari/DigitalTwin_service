#!/usr/bin/env python
from __future__ import division
def isclose(a, b, rel_tol=1e-03, abs_tol=1e-03):
    # return abs(a-b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
    return abs(a-b) <= abs_tol


a = 0

for x in range(0, -20, -1) + range(0, 20, 1):
	print(x)
	b=float(x/10000)
	print(b)
	print(isclose(a,b))
	print(" ")