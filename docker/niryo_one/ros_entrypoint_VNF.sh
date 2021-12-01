#!/bin/bash
set -e

# start openssh-server daemon
service ssh start

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/root/catkin_ws/devel/setup.bash"


# if only one argument is passed:
# - if it's "help", print some help
# - if it's an IP address, start the container as a master
# - if it's "driver", start it as a driver
if [ $# -eq 1 ]; then
	if [ $1 = "help" ] ; then
		echo "The following arguments are accepted:"
		echo "interface_master - Run the full ROS stack, with the remote driver+control+motionplanning layers" 
		echo "driver - Run the driver layer of the ROS stack"
		echo "control - Run the control layer of the ROS stack"
		echo "state - Run the state layer of the ROS stack"
		echo "motion_planning - Run the motion planning layer of the ROS stack"
		echo "robot_commander - Run the robot commander layer of the ROS stack"
		echo "help - Display this help message"
		exit
	elif [ $1 = "driver" ] ; then
		echo -e "\nDRIVER WILL BE EXECUTED\n"
		exec "bash"
		exit
	elif [ $1 = "control" ] ; then
		echo -e "\nCONTROL WILL BE EXECUTED\n"
		exec "bash"
		exit
	elif [ $1 = "state" ] ; then
		echo -e "\nSTATE WILL BE EXECUTED\n"
		exec "bash"
		exit
	elif [ $1 = "motion_planning" ] ; then
		echo -e "\nMOTION PLANNING WILL BE EXECUTED\n"
		exec "bash"
		exit
	elif  [ $1 = "robot_commander" ] ; then
		echo -e "\nROBOT COMMANDER WILL BE EXECUTED\n"
		exec "bash"
		exit
	elif [ $1 = "interface_master" ] ; then
		echo -e "\nINTERFACE (MASTER) WILL BE EXECUTED\n"
		roslaunch niryo_one_bringup simulation_vnf_split.launch
		exit
	fi
else
	echo "The following arguments are accepted:"
	echo "interface_master - Run the full ROS stack, with the remote driver+control+motionplanning layers" 
	echo "driver - Run the driver layer of the ROS stack"
	echo "control - Run the control layer of the ROS stack"
	echo "state - Run the state layer of the ROS stack"
	echo "motion_planning - Run the motion planning layer of the ROS stack"
	echo "robot_commander - Run the robot commander layer of the ROS stack"
	echo "help - Display this help message"
	exit
fi

exec "$@"
