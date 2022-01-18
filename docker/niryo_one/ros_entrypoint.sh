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
		echo "master <DRIVER_IP_ADDRESS> - Run the full ROS stack, with the remote driver" 
		echo "driver - Run the driver node of the ROS stack"
		echo "help - Display this help message"
		exit
	elif [ $1 = "driver" ] ; then
		exec "bash"
		exit
	fi
elif [ $# -eq 2 ]; then
	if [ $1 = "master" ]; then
		roslaunch niryo_one_bringup simulation_driver_split.launch
		exit
	fi
fi

exec "$@"
