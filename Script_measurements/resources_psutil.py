import time
import sys
from datetime import datetime
from psutil import cpu_times_percent, virtual_memory, cpu_times, cpu_percent

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

	# print("iteration,date,time,measurement_period,machine/VNF,user_cpu,nice_cpu,sys_cpu,idle_cpu,iowait,irq,softirq,steal,guest_cpu,guestnice_cpu,totalmem,availablemem,percentmem,usedmem,freemem,activemem,inactivemem,buffers,cached,shared")
	print("iteration,date,time,measurement_period,machine/VNF,sys_cpu,totalmem,availablemem,percentmem,usedmem,freemem,activemem,inactivemem,buffers,cached,shared")

	# tmp_list_1=cpu_times_percent(interval=0)
	_=cpu_times()
	_=cpu_percent()
	time.sleep(sys.argv[2])

	for i in range(sys.argv[1]):
		# print(psutil.cpu_percent(interval=0.1))
		# print(psutil.virtual_memory()[5])
		# print(i,",",sys.argv[2],",",sys.argv[3],",",psutil.cpu_percent(interval=sys.argv[2]),",",psutil.virtual_memory()[5])
		# print("{},{},{},{},{}".format(i, sys.argv[2], sys.argv[3], psutil.cpu_percent(interval=0), psutil.virtual_memory()[5]))
		
		# tmp_list_1=cpu_times_percent(interval=0)
		tmp_list_1=cpu_percent()
		tmp_list_2=virtual_memory()
		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		print("{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}".format(i, datestring, sys.argv[2], sys.argv[3],\
			# tmp_list_1[0], tmp_list_1[1], tmp_list_1[2], tmp_list_1[3], tmp_list_1[4], tmp_list_1[5], tmp_list_1[6], tmp_list_1[7], tmp_list_1[8], tmp_list_1[9],\
			tmp_list_1,\
			tmp_list_2[0], tmp_list_2[1], tmp_list_2[2], tmp_list_2[3], tmp_list_2[4], tmp_list_2[5], tmp_list_2[6], tmp_list_2[7], tmp_list_2[8], tmp_list_2[9]))
		time.sleep(sys.argv[2])