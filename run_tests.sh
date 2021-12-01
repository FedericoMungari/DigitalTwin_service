#!/bin/bash

NUM_ROBOTS_LIST="1 2 4 6 8 10 12"
NUM_ROBOTS_LIST="1 2 4 6 8 10 12 14 16"
# NUM_ROBOTS_LIST="6 8 10 12"
COMMAND_LIST="pose joints"
WAITINGTIME_LIST="0"


for num_robots_value in $NUM_ROBOTS_LIST; do
	for command_value in $COMMAND_LIST; do
		for waitingtime_value in $WAITINGTIME_LIST; do
			echo " "
			echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
			echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
			echo -e "\t\t\t\t     Number of robots: $num_robots_value"
			echo -e "\t\t\t\t  Command type of robots: $command_value"
			echo -e "\t\t\t\tWaiting time between commands: $waitingtime_value"
			echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
			echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

			. ./ROS_VNFsplit_srsLTE.sh $num_robots_value $command_value $waitingtime_value
		done
	done
done
