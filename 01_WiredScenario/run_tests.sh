#!/bin/bash

VBoxManage controlvm ROS_VNF_state poweroff 1>/dev/null 2>/dev/null


# NUM_ROBOTS_LIST="1 2 4 6 8 10"
NUM_ROBOTS_LIST="10"

# COMMAND_LIST="rosapi2 joints pose"
COMMAND_LIST="joints"

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
				loopvar=1
				if [[ $firstime -eq 1 ]]; then
					. ./Script_startRobots/ROS_VNFsplit_srsLTE.sh $num_robots_value $command_value $waitingtime_value "IDLEYES" $MEASUREMENT_TOOL
					firstime=0
				else
					echo " "
					echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
					echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
					echo -e "\t\t\t\t     Number of robots: $num_robots_value"
					echo -e "\t\t\t\t  Command type of robots: $command_value"
					echo -e "\t\t\t\tWaiting time between commands: $waitingtime_value"
					echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
					echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

					. ./Script_startRobots/ROS_VNFsplit_srsLTE.sh $num_robots_value $command_value $waitingtime_value "IDLENO" $MEASUREMENT_TOOL
				fi
				for i in $(seq $num_robots_value)
				do
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 9')
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 10')
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 11')
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@10.0.1.162 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 12')
					if [[ ${#filename} -gt 10 ]]; then
						lastline=$(sshpass -p ros ssh ros@10.0.1.162 "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; else loopvar=1; fi
						if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
					fi
				done
				. ./Script_startRobots/stop_and_start_VMs.sh
			done
		done
	done
done


# inter:	080027BC0A98
# comm:		0800276753D2
# mp:		0800270A3CC8
# state: 	0800273C009C
