#!/bin/bash

# REMEMBER to mount ssd
# 1) lsblk
# 	-> show mounted and unmounted partitions
# 2) udisksctl mount -b /dev/<to_be_mounted>
# 	-> mount the selected partition
# In .44:
# udisksctl mount -b /dev/nvme0n1

VBoxManage controlvm ROS_VNF_state poweroff 1>/dev/null 2>/dev/null


# NUM_ROBOTS_LIST="1 2 4 6 8 10"
NUM_ROBOTS_LIST="4"

# COMMAND_LIST="rosapi2 joints pose"
COMMAND_LIST="joints pose"

WAITINGTIME_LIST="0"

MEASUREMENT_TOOL=dockerstats
MEASUREMENT_TOOL=top
MEASUREMENT_TOOL=psutil


INTERFACE_MASTER_VM_IP=10.0.3.7


for num_robots_value in $NUM_ROBOTS_LIST; do
	for command_value in $COMMAND_LIST; do
		for waitingtime_value in $WAITINGTIME_LIST; do

			if [[ $command_value ==  "pose" ]]; then
				outputfolder_to_check="/home/ros/Output_script/02_LTE/pose/"
			elif [[ $command_value ==  "joints" ]]; then
				outputfolder_to_check="/home/ros/Output_script/02_LTE/joints/"
			elif [[ $command_value ==  "rosapi" ]]; then
				outputfolder_to_check="/home/ros/Output_script/02_LTE/rosapi/"
			elif [[ $command_value ==  "rosapi2" ]]; then
				outputfolder_to_check="/home/ros/Output_script/02_LTE/rosapi2/"
			fi

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
					. ./Script_startRobots/ROS_VNFsplit_srsLTE.sh $num_robots_value $command_value $waitingtime_value "IDLENO" $MEASUREMENT_TOOL
				fi
				for i in $(seq $num_robots_value)
				do
					filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt '"$outputfolder_to_check"'*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 8')
					if [[ ${#filename} -gt 10 ]]; then
						# lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
						numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep ERROR | wc -l ")
						if [[ $numb_of_occurrences -ne 0 ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt '"$outputfolder_to_check"'*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 9')
					if [[ ${#filename} -gt 10 ]]; then
						# lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
						numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep ERROR | wc -l ")
						if [[ $numb_of_occurrences -ne 0 ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt '"$outputfolder_to_check"'*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 10')
					if [[ ${#filename} -gt 10 ]]; then
						# lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
						numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep ERROR | wc -l ")
						if [[ $numb_of_occurrences -ne 0 ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt '"$outputfolder_to_check"'*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 11')
					if [[ ${#filename} -gt 10 ]]; then
						# lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
						numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep ERROR | wc -l ")
						if [[ $numb_of_occurrences -ne 0 ]]; then loopvar=0; break; fi
					fi
					filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt '"$outputfolder_to_check"'*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 12')
					if [[ ${#filename} -gt 10 ]]; then
						# lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
						# if [[ $lastline == *"timeout"* ]]; then loopvar=0; break; fi
						numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep ERROR | wc -l ")
						if [[ $numb_of_occurrences -ne 0 ]]; then loopvar=0; break; fi
					fi
				done
				. ./Script_startRobots/stop_and_start_VMs.sh
			done
		done
	done
done
