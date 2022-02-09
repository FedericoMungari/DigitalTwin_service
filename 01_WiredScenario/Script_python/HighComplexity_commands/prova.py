#!/usr/bin/env python
from __future__ import division
def isclose(a, b, rel_tol=1e-03, abs_tol=1e-03):
    # return abs(a-b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
    return abs(a-b) <= abs_tol


a = 0

for _ in range(0, 5, 1):
	for x in range(0, -20, -1) + range(1, 40, 1) + range(-1, -20-1, -1):
		a+=(1 if x > 0 else (0 if x == 0 else -1)) * 0.1
		print(x, "-->", a)
