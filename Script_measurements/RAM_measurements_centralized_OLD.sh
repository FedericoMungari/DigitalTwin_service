#!/bin/bash

vmIPArray=("10.0.1.157" "10.0.1.158" "10.0.1.159" "10.0.1.160" "10.0.1.161" "10.0.1.162")

count=$2
progressbar_interval=$((count/20))

echo -ne '| ........................................ |      (0%)\r'

for i in $(seq $count); do
	
	for vmip in ${vmIPArray[@]}; do
		if [[ "$vmip" == "${vmIPArray[0]}" ]] && [ ${i} -eq 1 ]
		then
			sshpass -p root ssh root@$vmip 'cat /proc/meminfo | grep "MemFree" | '  > "$1"
		else
			 >> "$1"
		fi
		
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
