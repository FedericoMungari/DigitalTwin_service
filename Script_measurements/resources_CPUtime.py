#!/usr/bin/env python

import sys
import time
from datetime import datetime
from psutil import cpu_times

if len(sys.argv)!=2:
	print("E R R O R:\nProblem with input quantities")
	print("Please insert:")
	print("VAR 1 : measurement time window")

else:

	sys.argv[1] = float(sys.argv[1])

	date1=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
	cpu1=cpu_times()
	time.sleep(sys.argv[1])
	cpu2=cpu_times()
	date2=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")

	print("date,time,user,nice,system,idle,iowait,irq,softirq,steal,guest,guest_nice")
	print("{},{},{},{},{},{},{},{},{},{},{}".format(date1, cpu1[0], cpu1[1], cpu1[2], cpu1[3], cpu1[4], cpu1[5], cpu1[6], cpu1[7], cpu1[8], cpu1[9]))
	print("{},{},{},{},{},{},{},{},{},{},{}".format(date2, cpu2[0], cpu2[1], cpu2[2], cpu2[3], cpu2[4], cpu2[5], cpu2[6], cpu2[7], cpu2[8], cpu2[9]))
	print("{},{},{},{},{},{},{},{},{},{},{}".format(date2, cpu2[0]-cpu1[0], cpu2[1]-cpu1[1], cpu2[2]-cpu1[2], cpu2[3]-cpu1[3], cpu2[4]-cpu1[4],\
													cpu2[4]-cpu1[4], cpu2[6]-cpu1[6], cpu2[7]-cpu1[7], cpu2[8]-cpu1[8], cpu2[9]-cpu1[9]))
	# print(cpu2[0]-cpu1[0] + cpu2[1]-cpu1[1] + cpu2[2]-cpu1[2] + cpu2[3]-cpu1[3] + cpu2[4]-cpu1[4] + cpu2[4]-cpu1[4] + cpu2[6]-cpu1[6] + cpu2[7]-cpu1[7] + cpu2[8]-cpu1[8] + cpu2[9]-cpu1[9])