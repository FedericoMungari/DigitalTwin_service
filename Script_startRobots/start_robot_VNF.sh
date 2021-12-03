#!/bin/bash

# Le docker network devono essere create anticipatamente su ogni VM
# 	 docker network create -o "com.docker.network.bridge.name":"ros_bridge" --subnet="10.2.0.0/24" ros_driver
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.5.0/24" ros_controller
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.4.0/24" ros_state
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.3.0/24" ros_motionplanning
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.2.0/24" ros_command
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.1.0/24" ros_interface

measurement_iteration="4000"
measurement_period="0.1"

NOF_ACTIVE_ROBOTS=0

declare -a Interface_IP_Set

function start_robot () {

	NOF_ACTIVE_ROBOTS=$((NOF_ACTIVE_ROBOTS+1))
	echo -e "\n\nSTEP $((7+2*(NOF_ACTIVE_ROBOTS-1))): robot activating"
	echo -e "\t -* Activating robot #$NOF_ACTIVE_ROBOTS ..."

	sshpass -p$1 ssh $2@$3 "docker run -dit --rm --name driver_robot_$((NOF_ACTIVE_ROBOTS)) --hostname driver --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_driver --ip 10.2.0.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot driver"
	DRIVER_IP=10.2.0.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Diver IP: $DRIVER_IP"
	# echo " "

	sshpass -p$1 ssh $2@$4 "docker run -dit --rm --name controller_robot_$((NOF_ACTIVE_ROBOTS)) --hostname control --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_controller --ip 10.1.5.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot control"
	CONTROL_IP=10.1.5.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Control IP: $CONTROL_IP"
	# echo " "

	sshpass -p$1 ssh $2@$5 "docker run -dit --rm --name state_robot_$((NOF_ACTIVE_ROBOTS)) --hostname state --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_state --ip 10.1.4.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot state"
	STATE_IP=10.1.4.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "State IP: $STATE_IP"
	# echo " "

	sshpass -p$1 ssh $2@$6 "docker run -dit --rm --name motionplanning_robot_$((NOF_ACTIVE_ROBOTS)) --hostname motion_planning --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_motionplanning --ip 10.1.3.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot motion_planning"
	MOTIONPLANNING_IP=10.1.3.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Motion planning IP: $MOTIONPLANNING_IP"
	# echo " "

	sshpass -p$1 ssh $2@$7 "docker run -dit --rm --name commander_robot_$((NOF_ACTIVE_ROBOTS))  --hostname robot_commander --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_command --ip 10.1.2.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot robot_commander"
	ROBOTCOMMANDER_IP=10.1.2.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Robot commander IP: $ROBOTCOMMANDER_IP"
	# echo " "

	sleep 10

	interface_trial=0

	if [[ $NOF_ACTIVE_ROBOTS -eq 1 ]]; then

		while [ $(sshpass -p$1 ssh $2@$8 "docker ps" | wc -l) -ne $((NOF_ACTIVE_ROBOTS+1)) ] 
		do
			interface_trial=$((interface_trial+1))
			echo "Interface: istantiation trial #$interface_trial"
			sshpass -p$1 ssh $2@$8 "docker run -dit --rm --name interfacemaster_robot_$((NOF_ACTIVE_ROBOTS)) --hostname master --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --network ros_interface --ip 10.1.1.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot interface_master"
			. ./Script_startRobots/mysleep.sh 60
		done
		INTERFACE_IP=10.1.1.$((NOF_ACTIVE_ROBOTS+1))
		echo -e "Interface commander IP:  $INTERFACE_IP"
	else
		sshpass -p$1 ssh $2@$8 "docker run -dit --rm --name interfacemaster_robot_$((NOF_ACTIVE_ROBOTS)) --hostname master --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --network ros_interface --ip 10.1.1.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot interface_master"
		INTERFACE_IP=10.1.1.$((NOF_ACTIVE_ROBOTS+1))
		echo -e "Interface commander IP:  $INTERFACE_IP"
	fi

	. ./Script_startRobots/mysleep.sh 20

	echo -e "\n\nSTEP $((8+2*(NOF_ACTIVE_ROBOTS-1))): CPU measurements and RAM usage with VMs hosting idle containers"
	echo "REMEMBER : already istantiated containers : $NOF_ACTIVE_ROBOTS"
	echo -e "\t\t. . . S k i p p i n g . . ."
	# read -p "Do you want to measure the CPU consumption of VMs hosting $NOF_ACTIVE_ROBOTS idle containers??`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
	# echo " "
	# if [[ $REPLY =~ ^[Yy]$ ]]
	# then
		# echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting $NOF_ACTIVE_ROBOTS idle containers measuring . . ."
		# # . ./Script_measurements/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_iteration LocalHost && . ./RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_iteration LocalHost

		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_interface" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_command" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_motionplanning" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_state" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_control" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period ROS_VNF_driver" 1>/dev/null &
		# sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost 1>/dev/null &
		# sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out $measurement_iteration $measurement_period LocalHost 1>/dev/null &

		# . ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+120" | bc)

	# else
		# echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting $NOF_ACTIVE_ROBOTS idle containers will not be measured . . ."
	# fi

	Interface_IP_Set+=( $INTERFACE_IP )

}

INTERFACE_MASTER_VM_IP=10.0.1.162
ROBOTCOMMANDER_VM_IP=10.0.1.161
MOTIONPLANNING_VM_IP=10.0.1.185
STATE_VM_IP=10.0.1.159
CONTROLLER_VM_IP=10.0.1.158
DRIVER_VM_IP=10.0.1.175

VM_USERNAME=ros
VM_PSW=ros

n=0;
# read -p $'\nPress the number of robots to start\n' key
n_robots=$1
echo -e "$n_robots robots will be istantiated\n"

while true; do
    start_robot $VM_PSW $VM_USERNAME $DRIVER_VM_IP $CONTROLLER_VM_IP $STATE_VM_IP $MOTIONPLANNING_VM_IP $ROBOTCOMMANDER_VM_IP $INTERFACE_MASTER_VM_IP
    n=$((n+1))
    if [[ $n -eq $n_robots ]]; then
		break
    fi
done

. ./Script_startRobots/mysleep.sh 60

commandname=$2

if [[ $commandname ==  "pose" ]]; then

	echo -e "\nIDLE containers: CPU and RAM measurement --> *_IDLE_$((n_robots))containers.out"
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
	sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
		sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
	sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost &>/dev/null &
	sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period LocalHost &>/dev/null &

	. ./Script_startRobots/mysleep.sh $(echo "4*$measurement_iteration*$measurement_period" | bc)

fi


echo -e "\n\nSTEP $((9+2*(NOF_ACTIVE_ROBOTS-1)+1)): Run python script to send move pose or joints commands to the robot"

# read -p $'\nPress j/J if u want to send move joint commands.\nPress g/G if u want to send open/close gripper commands.\nPress p/P if u want to send move pose commands.\nAny other char/string will trigger move pose commands\n' commandtype
# if [[ $commandtype =~ ^[Jj]$ ]] 
# then
# elif [[ $commandtype =~ ^[Gg]$ ]]
# then
# else
# fi

if [[ $commandname ==  "joints" ]]; then

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between move joint commands to the robot\n' wait_between_comm
	echo "A move joint command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_joints.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*11" | bc))/g" ./Script_python/script_joints.py
		echo "Sending script_joints.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_joints.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_joints.py'
		# echo "Running script.py"
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_joints.py 1> /Output_script/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done

elif [[ $commandname ==  "gripper" ]]; then

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between open/close gripper commands to the robot\n' wait_between_comm
	echo "An open/close gripper command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_gripper.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*10" | bc))/g" ./Script_python/script_gripper.py
		echo "Sending script_gripper.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_gripper.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_gripper.py'
	#	(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_gripper.py' 1> ./Output_script/script_gripper_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> ./Output_script/script_gripper_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_gripper.py 1> /Output_script/script_gripper_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_gripper_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
	done

else

	commandname="pose"

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between move pose commands to the robot\n' wait_between_comm
	echo "A move pose command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_pose.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*10" | bc))/g" ./Script_python/script_pose.py
		echo "Sending script_pose.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_pose.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_pose.py'
		# echo "Running script.py"
		#(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_pose.py' 1> ./Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> ./Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_pose.py 1> /Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)

		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done
fi

sleep 5

echo -e "\n\nSTEP $((9+2*(NOF_ACTIVE_ROBOTS-1)+2)): CPU measurements and RAM usage with VM hosting active containers (python script is running)"
# read -p "Do you want to measure the CPU consumption and RAM usage of VMs hosting active containers??`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
# echo " "
# if [[ $REPLY =~ ^[Yy]$ ]]
# then
if true; then
	echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting active containers measuring . . ."
	if [[ $commandname ==  "joints" ]]; then
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
		sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost &>/dev/null &
		sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period LocalHost &>/dev/null &

		. ./Script_startRobots/mysleep.sh $(echo "4*$measurement_iteration*$measurement_period" | bc)

	elif [[ $commandname ==  "gripper" ]]; then
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
		sh ./CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost &>/dev/null &
		sh ./RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_gripper_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period LocalHost &>/dev/null &

		. ./Script_startRobots/mysleep.sh $(echo "4*$measurement_iteration*$measurement_period" | bc)

	else
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
			sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
		sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost  &>/dev/null &
		sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period LocalHost &>/dev/null &

		. ./Script_startRobots/mysleep.sh $(echo "4*$measurement_iteration*$measurement_period" | bc)
	fi

else
	echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting active containers will not be measured . . ."
fi

echo "     ...     **Exit from the main script execution**     ...     "
echo -e "\n\n"
