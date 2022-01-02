import psutil
import time
import sys

# print(len(sys.argv))
# print(list(sys.argv))

if len(sys.argv)!=4:
	print("E R R O R:\nProblem with input quantities")
	print("Please insert:")
	print("VAR 1 : number of iteration")
	print("VAR 2 : sleeping time between measurements")
	print("VAR 3 : machine name")
	# $3 : sleeping time between measurements
	# $4 : machine name

else:

	sys.argv[1] = int(sys.argv[1])
	sys.argv[2] = float(sys.argv[2])

	print("iteration,measurement_period,machine/VNF,user_cpu,ram")

	for i in range(sys.argv[1]):
		# print(psutil.cpu_percent(interval=0.1))
		# print(psutil.virtual_memory()[5])
		# print(i,",",sys.argv[2],",",sys.argv[3],",",psutil.cpu_percent(interval=sys.argv[2]),",",psutil.virtual_memory()[5])
		print("{},{},{},{},{}".format(i, sys.argv[2], sys.argv[3], psutil.cpu_times_percent(interval=0)[0], psutil.virtual_memory()[5]))
		time.sleep(sys.argv[2])
