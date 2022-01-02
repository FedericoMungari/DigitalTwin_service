#!/bin/bash

# $1 : output file name
# $2 : test number of iteration
# $3 : sleeping time between measurements
# $4 : machine name

# echo "RAM: First variable $1"
# echo "RAM: Second variable $2"
# echo "RAM: Third variable $3"
# echo "RAM: Fourth variable $4"

default_sleepingtime=1
sleepingtime="${3:-$def_sleepingtime}"

default_count=300
count="${2:-$default_count}"

default_name="machine_name"
machine_name="${4:-$default_name}"

progressbar_interval=$((count/20))

# echo -ne '| ........................................ |      (0%)\r'

RAMtotal=$( cat /proc/meminfo | grep MemTotal | sed "s/  */ /g" | cut -d " " -f 2)

echo "iteration,measurement_period,machine/VNF,RAMTotal,RAMFree,RAMAvailable,RAM_usage" > "$1"

for i in $(seq $count); do
	
	# if [ $i -eq 1 ]; then
	# 	echo "$i,$machine_name,$(($RAMtotal - $(cat /proc/meminfo | grep MemFree | sed "s/  */ /g" | cut -d " " -f 2)))" > "$1"
	# else
	# 	echo "$i,$machine_name,$(($RAMtotal - $(cat /proc/meminfo | grep MemFree | sed "s/  */ /g" | cut -d " " -f 2)))" >> "$1"
	# fi
	echo "$i,$sleepingtime,$machine_name,$RAMtotal,$(cat /proc/meminfo | grep MemFree | sed "s/  */ /g" | cut -d " " -f 2),$(cat /proc/meminfo | grep MemAvailable | sed "s/  */ /g" | cut -d " " -f 2),$(($RAMtotal - $(cat /proc/meminfo | grep MemAvailable | sed "s/  */ /g" | cut -d " " -f 2)))" >> "$1"
	sleep $sleepingtime
	
	# if [ ${i} -eq "$progressbar_interval" ]; then
		# echo -ne '| ##...................................... |      (5%)\r'
	# elif [ ${i} -eq "$((2*progressbar_interval))" ]; then
		# echo -ne '| ####.................................... |     (10%)\r'
	# elif [ ${i} -eq "$((3*progressbar_interval))" ]; then
		# echo -ne '| ######.................................. |     (15%)\r'
	# elif [ ${i} -eq "$((4*progressbar_interval))" ]; then
		# echo -ne '| ########................................ |     (20%)\r'
	# elif [ ${i} -eq "$((5*progressbar_interval))" ]; then
		# echo -ne '| ##########.............................. |     (25%)\r'
	# elif [ ${i} -eq "$((6*progressbar_interval))" ]; then
		# echo -ne '| ############............................ |     (30%)\r'
	# elif [ ${i} -eq "$((7*progressbar_interval))" ]; then
		# echo -ne '| ##############.......................... |     (35%)\r'
	# elif [ ${i} -eq "$((8*progressbar_interval))" ]; then
		# echo -ne '| ################........................ |     (40%)\r'
	# elif [ ${i} -eq "$((9*progressbar_interval))" ]; then
		# echo -ne '| ##################...................... |     (45%)\r'
	# elif [ ${i} -eq "$((10*progressbar_interval))" ]; then
		# echo -ne '| ####################.................... |     (50%)\r'
	# elif [ ${i} -eq "$((11*progressbar_interval))" ]; then
		# echo -ne '| ######################.................. |     (55%)\r'
	# elif [ ${i} -eq "$((12*progressbar_interval))" ]; then
		# echo -ne '| ########################................ |     (60%)\r'
	# elif [ ${i} -eq "$((13*progressbar_interval))" ]; then
		# echo -ne '| ##########################.............. |     (65%)\r'
	# elif [ ${i} -eq "$((14*progressbar_interval))" ]; then
		# echo -ne '| ############################............ |     (70%)\r'
	# elif [ ${i} -eq "$((15*progressbar_interval))" ]; then
		# echo -ne '| ##############################.......... |     (75%)\r'
	# elif [ ${i} -eq "$((16*progressbar_interval))" ]; then
		# echo -ne '| ################################........ |     (80%)\r'
	# elif [ ${i} -eq "$((17*progressbar_interval))" ]; then
		# echo -ne '| ##################################...... |     (85%)\r'
	# elif [ ${i} -eq "$((18*progressbar_interval))" ]; then
		# echo -ne '| ####################################.... |     (90%)\r'
	# elif [ ${i} -eq "$((19*progressbar_interval))" ]; then
		# echo -ne '| ######################################.. |     (95%)\r'
	# elif [ ${i} -eq "$((20*progressbar_interval))" ]; then
		# echo -ne '| ######################################## |    (100%)\r'
		# echo -ne '\n'
	# fi
done
