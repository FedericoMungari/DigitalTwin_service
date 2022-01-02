import psutil
import time
import sys


if len(sys.argv)!=4:
	print("E R R O R:\nProblem with input quantities")
	print("Please insert:")
	print("VAR 1 : number of iteration")
	print("VAR 2 : sleeping time between measurements")
	print("VAR 3 : machine name")

else:

	sys.argv[1] = int(sys.argv[1])
	sys.argv[2] = float(sys.argv[2])

	print("iteration,measurement_period,machine/VNF,user_cpu")

	for i in range(sys.argv[1]):
		
		print(psutil.cpu_times())
		time.sleep(sys.argv[2])
