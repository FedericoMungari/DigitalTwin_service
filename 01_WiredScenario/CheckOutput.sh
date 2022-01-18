#!/bin/bash

VBoxManage controlvm ROS_VNF_state poweroff 1>/dev/null 2>/dev/null


# NUM_ROBOTS_LIST="1 2 4 6 8 10"
NUM_ROBOTS_LIST="4"

# COMMAND_LIST="rosapi2 joints pose"
COMMAND_LIST="pose"

WAITINGTIME_LIST="0"

MEASUREMENT_TOOL=dockerstats
MEASUREMENT_TOOL=top
MEASUREMENT_TOOL=psutil


for num_robots_value in $NUM_ROBOTS_LIST; do
	for command_value in $COMMAND_LIST; do
		for waitingtime_value in $WAITINGTIME_LIST; do
			clear
			echo " "
			echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
			echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
			echo -e "\t\t\t\t     Number of robots: $num_robots_value"
			echo -e "\t\t\t\t  Command type of robots: $command_value"
			echo -e "\t\t\t\tWaiting time between commands: $waitingtime_value"
			echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
			echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

			loopvar=0
			firstime=1
			while [ $loopvar -eq 0 ]
			do
				echo "Entering the loop"
				loopvar=1
				for i in $(seq $num_robots_value)
				do
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 9')
					echo "step 1: filename $filename"
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; echo "Action server timeout: found"; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 10')
					echo "step 2: filename $filename"
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; echo "Action server timeout: found"; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 11')
					echo "step 3: filename $filename"
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; echo "Action server timeout: found"; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 12')
					echo "step 3: filename $filename"
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; echo "Action server timeout: found"; break; fi
					fi
				done
				# . ./Script_startRobots/stop_and_start_VMs.sh
				echo "loop done"
			done
		done
	done
done


# inter:	080027BC0A98
# comm:		0800276753D2
# mp:		0800270A3CC8
# state: 	0800273C009C