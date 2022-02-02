#!/usr/bin/env python

import sys
import time
from datetime import datetime
from psutil import cpu_times
from psutil import Process

if len(sys.argv)!=4:
	print("E R R O R:\nProblem with input quantities")
	print("Please insert:")
	print("VAR 1 : measurement iteration number")
	print("VAR 2 : measurement periodicity [s]")
	print("VAR 3 : PID")

	'''
	Remember:
	The script gives the overall CPU time of a process in an interval of time equal to t_1=sys.argv[1]*sys.argv[2]. 
	Just 2 samples will be given: the initial (at t_0 == the instant in which the script is launched) and the final (at t_1) CPU times.
	
	Then the CPU time associated to the process sys.argv[3] will be:
		---> CPU_time(t_1) - CPU_time(t_0)
	'''

else:

	sys.argv[1] = float(sys.argv[1])
	sys.argv[2] = float(sys.argv[2])
	sys.argv[3] = int(sys.argv[3])
	sleepingtime = sys.argv[1] * sys.argv[2]

	p = Process(sys.argv[3])

	date1=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
	cpu1=p.cpu_times()
	time.sleep(sleepingtime)
	cpu2=p.cpu_times()
	date2=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")

	print("meas_samples,meas_periodicity,date,time,user,system,children_user,children_system")
	print("{},{},{},{},{},{},{}".format(sys.argv[1],sys.argv[2],date1, cpu1[0], cpu1[1], cpu1[2], cpu1[3]))
	print("{},{},{},{},{},{},{}".format(sys.argv[1],sys.argv[2],date2, cpu2[0], cpu2[1], cpu2[2], cpu2[3]))
	print("{},{},{},{},{},{},{}".format(sys.argv[1],sys.argv[2],date2, cpu2[0]-cpu1[0], cpu2[1]-cpu1[1], cpu2[2]-cpu1[2], cpu2[3]-cpu1[3]))
	### print(cpu2[0]-cpu1[0] + cpu2[1]-cpu1[1] + cpu2[2]-cpu1[2] + cpu2[3]-cpu1[3] + cpu2[4]-cpu1[4] + cpu2[4]-cpu1[4] + cpu2[6]-cpu1[6] + cpu2[7]-cpu1[7] + cpu2[8]-cpu1[8] + cpu2[9]-cpu1[9])


