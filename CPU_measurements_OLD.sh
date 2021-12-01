#!/bin/bash

# VBoxManage metrics enable $vmname CPU/Load/User,CPU/Load/Kernel,RAM/Usage/Used,Disk/Usage/Used,Net/Rate/Rx,Net/Rate/Tx
vmnameArray=("ROS_VNF_driver" "ROS_VNF_control" "ROS_VNF_state" "ROS_VNF_motionplanning" "ROS_VNF_command" "ROS_VNF_interface")
metricsArray=("CPU/Load" "RAM/Usage" "Disk/Usage" "Net/Rate" "Guest/CPU/Load" "Guest/RAM/Usage" "Guest/RAM/Pagefile")
metricsArray_query=("CPU/Load/User" "CPU/Load/Kernel" "RAM/Usage/Used" "Disk/Usage/Used" "Net/Rate/Rx" "Net/Rate/Tx" "Guest/CPU/Load/User" "Guest/CPU/Load/Kernel" "Guest/CPU/Load/Idle" "Guest/CPU/Load/Total" "Guest/CPU/Load/Free" "Guest/CPU/Load/Balloon" "Guest/CPU/Load/Shared")
for vmname in ${vmnameArray[@]}; do
	VBoxManage metrics enable $vmname 
	VBoxManage metrics setup --period 1 --samples 1 $vmname $( IFS=','; echo "${metricsArray[*]}" )
	# VBoxManage metrics query $vmname 
done

sleep 2

count=$2
progressbar_interval=$((count/20))

echo -ne '| ........................................ |      (0%)\r'

for i in $(seq $count); do
	
	for vmname in ${vmnameArray[@]}; do
		if [[ "$vmname" == "${vmnameArray[0]}" ]] # && [ ${i} -eq 1 ]
		then
			VBoxManage metrics query $vmname $( IFS=','; echo "${metricsArray_query[*]}" ) > CPUconsumption_tmp.out
		else
			VBoxManage metrics query $vmname $( IFS=','; echo "${metricsArray_query[*]}" ) >> CPUconsumption_tmp.out
		fi
		
	done
	
	# Process the CPUconsumption_tmp.out file, and save the desired data into $1
	if [ ${i} -eq 1 ]; then
		# we have to create the file $1
		echo "MEASUREMENTS,VM,"$( IFS=','; echo "${metricsArray_query[*]}") > $1
	fi
	for vmname in ${vmnameArray[@]}; do
		declare -a var_array=()
		for metric in ${metricsArray_query[@]}; do
			# we have to append to the file $1
			var=$(cat CPUconsumption_tmp.out | grep $vmname | grep $metric | head -1 | sed 's/  */ /g' | cut -d " " -f 3 | sed 's/%//')
			# echo $var
			var_array+=($var)
			# echo $( IFS=','; echo "${var_array[*]}")
		done
		echo $i,$vmname,$( IFS=','; echo "${var_array[*]}") >> "$1"
	done
	
	sleep 1
	
	if [ ${i} -eq "$progressbar_interval" ]; then
		echo -ne '| ##...................................... |      (5%)\r'
	elif [ ${i} -eq "$((2*progressbar_interval))" ]; then
		echo -ne '| ####.................................... |     (10%)\r'
	elif [ ${i} -eq "$((3*progressbar_interval))" ]; then
		echo -ne '| ######.................................. |     (15%)\r'
	elif [ ${i} -eq "$((4*progressbar_interval))" ]; then
		echo -ne '| ########................................ |     (20%)\r'
	elif [ ${i} -eq "$((5*progressbar_interval))" ]; then
		echo -ne '| ##########.............................. |     (25%)\r'
	elif [ ${i} -eq "$((6*progressbar_interval))" ]; then
		echo -ne '| ############............................ |     (30%)\r'
	elif [ ${i} -eq "$((7*progressbar_interval))" ]; then
		echo -ne '| ##############.......................... |     (35%)\r'
	elif [ ${i} -eq "$((8*progressbar_interval))" ]; then
		echo -ne '| ################........................ |     (40%)\r'
	elif [ ${i} -eq "$((9*progressbar_interval))" ]; then
		echo -ne '| ##################...................... |     (45%)\r'
	elif [ ${i} -eq "$((10*progressbar_interval))" ]; then
		echo -ne '| ####################.................... |     (50%)\r'
	elif [ ${i} -eq "$((11*progressbar_interval))" ]; then
		echo -ne '| ######################.................. |     (55%)\r'
	elif [ ${i} -eq "$((12*progressbar_interval))" ]; then
		echo -ne '| ########################................ |     (60%)\r'
	elif [ ${i} -eq "$((13*progressbar_interval))" ]; then
		echo -ne '| ##########################.............. |     (65%)\r'
	elif [ ${i} -eq "$((14*progressbar_interval))" ]; then
		echo -ne '| ############################............ |     (70%)\r'
	elif [ ${i} -eq "$((15*progressbar_interval))" ]; then
		echo -ne '| ##############################.......... |     (75%)\r'
	elif [ ${i} -eq "$((16*progressbar_interval))" ]; then
		echo -ne '| ################################........ |     (80%)\r'
	elif [ ${i} -eq "$((17*progressbar_interval))" ]; then
		echo -ne '| ##################################...... |     (85%)\r'
	elif [ ${i} -eq "$((18*progressbar_interval))" ]; then
		echo -ne '| ####################################.... |     (90%)\r'
	elif [ ${i} -eq "$((19*progressbar_interval))" ]; then
		echo -ne '| ######################################.. |     (95%)\r'
	elif [ ${i} -eq "$((20*progressbar_interval))" ]; then
		echo -ne '| ######################################## |    (100%)\r'
		echo -ne '\n'
	fi
	
done
