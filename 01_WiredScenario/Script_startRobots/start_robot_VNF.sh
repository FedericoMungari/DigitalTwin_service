#!/bin/bash

# Le docker network devono essere create anticipatamente su ogni VM
# 	 docker network create -o "com.docker.network.bridge.name":"ros_bridge" --subnet="10.2.0.0/24" ros_driver
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.5.0/24" ros_controller
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.4.0/24" ros_state
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.3.0/24" ros_motionplanning
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.2.0/24" ros_command
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.1.0/24" ros_interface

measurement_iteration="1800"
measurement_period="0.5"

NOF_ACTIVE_ROBOTS=0

declare -a Interface_IP_Set
# declare -a Driver_IP_Set
# declare -a Controller_IP_Set
# declare -a Commander_IP_Set

function start_robot () {

	NOF_ACTIVE_ROBOTS=$((NOF_ACTIVE_ROBOTS+1))
	echo -e "\n\nSTEP $((7+2*(NOF_ACTIVE_ROBOTS-1))): robot activating"
	echo -e "\t -* Activating robot #$NOF_ACTIVE_ROBOTS ..."

	l7rtt_sleep=$((90*(${10}-$NOF_ACTIVE_ROBOTS+1)))

	sshpass -p$1 ssh $2@$3 "docker run -dit --rm --name driver_robot_$((NOF_ACTIVE_ROBOTS)) --hostname driver --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_driver --ip 10.2.0.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot driver "$l7rtt_sleep" "$9" "${10}" "$NOF_ACTIVE_ROBOTS
	DRIVER_IP=10.2.0.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Diver IP: $DRIVER_IP"
	# echo " "

	sshpass -p$1 ssh $2@$4 "docker run -dit --rm --name controller_robot_$((NOF_ACTIVE_ROBOTS)) --hostname control --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_controller --ip 10.1.5.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot control "$l7rtt_sleep" "$9" "${10}" "$NOF_ACTIVE_ROBOTS
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

	sleep 20

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

	. ./Script_startRobots/mysleep.sh 60

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

		
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out" 1>/dev/null &
	# python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_IDLE_$((NOF_ACTIVE_ROBOTS))containers.out &
	# . ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period*3" | bc)



	# else
		# echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting $NOF_ACTIVE_ROBOTS idle containers will not be measured . . ."
	# fi

	Interface_IP_Set+=( $INTERFACE_IP )
	# Driver_IP_Set+=( $DRIVER_IP )
	# Controller_IP_Set+=( $CONTROL_IP )
	# Commander_IP_Set+=( $ROBOTCOMMANDER_IP )

}

INTERFACE_MASTER_VM_IP=10.0.1.162
ROBOTCOMMANDER_VM_IP=10.0.1.161
MOTIONPLANNING_VM_IP=10.0.1.160
STATE_VM_IP=10.0.1.159
CONTROLLER_VM_IP=10.0.1.188
DRIVER_VM_IP=10.0.1.175

VM_USERNAME=ros
VM_PSW=ros

n=0;
# read -p $'\nPress the number of robots to start\n' key
n_robots=$1
echo -e "$n_robots robots will be istantiated\n"

commandname=$2

while true; do
    start_robot $VM_PSW $VM_USERNAME $DRIVER_VM_IP $CONTROLLER_VM_IP $STATE_VM_IP $MOTIONPLANNING_VM_IP $ROBOTCOMMANDER_VM_IP $INTERFACE_MASTER_VM_IP $commandname $n_robots
    n=$((n+1))
    if [[ $n -eq $n_robots ]]; then
		break
    fi
done

. ./Script_startRobots/mysleep.sh 20

IDLEmeas_flag=$4

meas_tool=$5

# for ipdriver in "${Driver_IP_Set[@]}"
# do
	# echo "Sending subscriber_DL.py to the driver"
	# sshpass -p root scp ./Script_ApplicationRTT/subscriber_DL.py root@$ipdriver:/
	# # sleep 1
	# # echo "driver: chmod +x subscriber_DL.py"
	# # sshpass -p root ssh root@$ipdriver "echo root | sudo -S chmod +x /subscriber_DL.py"
	# echo "Sending publisher_UL.py to the driver"
	# sshpass -p root scp ./Script_ApplicationRTT/publisher_UL.py root@$ipdriver:/
	# # echo "driver: chmod +x publisher_UL.py"
	# # sshpass -p root sshroot@$ipdriver "echo root | sudo -S chmod +x /publisher_UL.py "
# done
# 
# for ipcontroller in "${Controller_IP_Set[@]}"
# do
	# echo "Sending subscriber_UL.py to the control"
	# sshpass -p root scp ./Script_ApplicationRTT/subscriber_UL.py root@$ipcontroller:/
	# # sleep 1
	# # echo "control: chmod +x subscriber_UL.py"
	# # sshpass -p root ssh root@$ipcontroller "echo root |sudo -S chmod +x /subscriber_UL.py "
	# echo "Sending publisher_DL.py to the control"
	# sshpass -p root scp ./Script_ApplicationRTT/publisher_DL.py root@$ipcontroller:/
	# # echo "control: chmod +x publisher_DL.py"
	# # sshpass -p root sshroot@$ipcontroller "echo root |sudo -S chmod +x /publisher_DL.py "
# done


if [[ $IDLEmeas_flag ==  "IDLEYES" && $commandname ==  "pose" ]]
then

	echo -e "\nIDLE containers: CPU and RAM measurement --> *_IDLE_$((n_robots))containers.out"
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
		# sh ~/RAM_measurements.sh RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
	# sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_IDLE_$((n_robots))containers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost &>/dev/null &
	# sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period LocalHost &>/dev/null &

	if [[ $meas_tool ==  "psutil" ]]; then
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_interface 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_command 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_motionplanning 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_state 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_control 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py "$measurement_iteration" "$measurement_period" ROS_VNF_driver 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_IDLE_$((n_robots))containers.out 2> /dev/null &
		python3 -u ./Script_measurements/resources_CPUtime.py 1500 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_IDLE_$((n_robots))containers.out $measurement_iteration $measurement_period LocalHost 2> /dev/null &
	elif [[ $meas_tool ==  "dockerstats" ]]; then
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_interface" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_command" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_motionplanning" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_state" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_control" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_IDLE_$((n_robots))containers.out ROS_VNF_driver" 1>/dev/null &
		sh ./Script_measurements/resources_dockerstats.sh ./Output/00_HostMetrics/resources_dockerstats_IDLE_$((n_robots))containers.out LocalHost 2> /dev/null &
	fi

	echo "sleep"
	. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

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

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_joints_logfile.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*8" | bc))/g" ./Script_python/script_joints_logfile.py
		echo "Sending script_joints_logfile.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_joints_logfile.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_joints_logfile.py'
		# echo "Running script.py"
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_joints_logfile.py --filename /Output_script/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_joints.py --duration 3000 1> /Output_script/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done

elif [[ $commandname ==  "gripper" ]]; then

	wait_between_comm=$3
	if [[ $wait_between_comm -eq 0 ]]; then
		wait_between_comm=1
	fi
	# read -p $'\nPress the waiting time between open/close gripper commands to the robot\n' wait_between_comm
	echo "An open/close gripper command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_gripper.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*8" | bc))/g" ./Script_python/script_gripper.py
		echo "Sending script_gripper.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_gripper.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_gripper.py'
	#	(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_gripper.py' 1> ./Output_script/script_gripper_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> ./Output_script/script_gripper_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt &)
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_gripper.py --filename /Output_script/script_gripper_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_gripper_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_gripper.py 1> /Output_script/script_gripper_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_gripper_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
	done

elif [[ $commandname ==  "rosapi" ]]; then

	wait_between_comm=$3
	if [[ $wait_between_comm -eq 0 ]]; then
		# wait_between_comm=0.001
		wait_between_comm=$3
	fi
	# read -p $'\nPress the waiting time between open/close gripper commands to the robot\n' wait_between_comm
	echo "A move joints through ROS API command will be sent to the robots"
	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		echo "Sending script_ROSAPI.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_ROSAPI.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_ROSAPI.py'
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_ROSAPI.py --cmd_speed 0.1  --duration 3000 --filename /Output_script/script_rosapi_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_rosapi_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
	done

elif [[ $commandname ==  "rosapi2" ]]; then

	wait_between_comm=$3
	if [[ $wait_between_comm -eq 0 ]]; then
		# wait_between_comm=0.001
		wait_between_comm=$3
	fi
	# read -p $'\nPress the waiting time between open/close gripper commands to the robot\n' wait_between_comm
	echo "A move joints through ROS API command will be sent to the robots"

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*8" | bc))/g" ./Script_python/script_ROSAPI_2.py
		echo "Sending script_ROSAPI_2.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_ROSAPI_2.py root@$ipinterface:/
		sshpass -p root scp ./Script_python/ROSAPI_move_to_initposit.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_ROSAPI_2.py'
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /ROSAPI_move_to_initposit.py'
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /ROSAPI_move_to_initposit.py &&'"python /script_ROSAPI_2.py --cmd_speed 0.5 --duration 3000 --key_offset 0.1 --filename1 /Output_script/script_rosapi_2_subcommandoutput_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt --filename2 /Output_script/script_rosapi_2_targetoutput_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_rosapi_2_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /ROSAPI_move_to_initposit.py &&'"python -u /script_ROSAPI_2.py --cmd_speed 0.1 --duration 3000 --key_offset 0.1 --filename /Output_script/script_rosapi_2_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_rosapi_2_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /ROSAPI_move_to_initposit.py && python -u /script_ROSAPI_2.py --cmd_speed 0.1 --duration 30 --key_offset 0.1 --filename prova 
	done

else

	commandname="pose"

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between move pose commands to the robot\n' wait_between_comm
	echo "A move pose command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" ./Script_python/script_pose_logfile.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*8" | bc))/g" ./Script_python/script_pose_logfile.py
		echo "Sending script_pose_logfile.py to $ipinterface"
		sshpass -p root scp ./Script_python/script_pose_logfile.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_pose_logfile.py'
		# echo "Running script.py"
		#(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_pose_logfile.py' 1> ./Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> ./Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_pose_logfile.py --filename /Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_pose.py --duration 3000 1> /Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)

		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done
fi

. ./Script_startRobots/mysleep.sh 60

echo -e "\n\nSTEP $((9+2*(NOF_ACTIVE_ROBOTS-1)+2)): CPU measurements and RAM usage with VM hosting active containers (python script is running)"
# read -p "Do you want to measure the CPU consumption and RAM usage of VMs hosting active containers??`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
# echo " "
# if [[ $REPLY =~ ^[Yy]$ ]]
# then
if true; then
	echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting active containers measuring . . ."
	if [[ $commandname ==  "joints" ]]; then
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
		# sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost &>/dev/null &
		# sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period LocalHost &>/dev/null &

		if [[ $meas_tool ==  "psutil" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
			python3 -u ./Script_measurements/resources_CPUtime.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_joints_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
		elif [[ $meas_tool ==  "dockerstats" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_interface" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_command" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_motionplanning" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_state" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_control" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_driver" 1>/dev/null &
			sh ./Script_measurements/resources_dockerstats.sh ./Output/00_HostMetrics/resources_dockerstats_joints_$((n_robots))ACTIVE_freq$((wait_between_comm)).out LocalHost 2> /dev/null &
		fi

		. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)


	elif [[ $commandname ==  "rosapi" ]]; then

		if [[ $meas_tool ==  "psutil" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
			python3 -u ./Script_measurements/resources_CPUtime.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_rosapi_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
		elif [[ $meas_tool ==  "dockerstats" ]]
		then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_interface" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_command" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_motionplanning" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_state" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_control" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_driver" 1>/dev/null &
			sh ./Script_measurements/resources_dockerstats.sh ./Output/00_HostMetrics/resources_dockerstats_rosapi_$((n_robots))ACTIVE_freq$((wait_between_comm)).out LocalHost 2> /dev/null &
		fi

		. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

	elif [[ $commandname ==  "rosapi2" ]]; then

		if [[ $meas_tool ==  "psutil" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
			python3 -u ./Script_measurements/resources_CPUtime.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_rosapi_2_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
		elif [[ $meas_tool ==  "dockerstats" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_interface" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_command" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_motionplanning" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_state" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_control" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_driver" 1>/dev/null &
			sh ./Script_measurements/resources_dockerstats.sh ./Output/00_HostMetrics/resources_dockerstats_rosapi_2_$((n_robots))ACTIVE_freq$((wait_between_comm)).out LocalHost 2> /dev/null &
		fi

		. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

	elif [[ $commandname ==  "pose" ]]; then
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_interface &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_command &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_motionplanning &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_state &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_control &>/dev/null" 1>/dev/null &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver &>/dev/null &\
			# sh ~/RAM_measurements.sh RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period ROS_VNF_driver &>/dev/null" 1>/dev/null &
		# sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost  &>/dev/null &
		# sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out $measurement_iteration $measurement_period LocalHost &>/dev/null &

		if [[ $meas_tool ==  "psutil" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out" 1>/dev/null &
			python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
			python3 -u ./Script_measurements/resources_CPUtime.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_pose_$((NOF_ACTIVE_ROBOTS))ACTIVE_freq$((wait_between_comm)).out &
		elif [[ $meas_tool ==  "dockerstats" ]]; then
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_interface" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_command" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_motionplanning" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_state" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_control" 1>/dev/null &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/resources_dockerstats.sh resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out ROS_VNF_driver" 1>/dev/null &
			sh ./Script_measurements/resources_dockerstats.sh ./Output/00_HostMetrics/resources_dockerstats_pose_$((n_robots))ACTIVE_freq$((wait_between_comm)).out LocalHost 2> /dev/null &
		fi

		. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

	fi

else
	echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting active containers will not be measured . . ."
fi

echo "     ...     **Exit from the main script execution**     ...     "
echo -e "\n\n"











# source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_ROSAPI_2.py --cmd_speed 0.2 --duration 30 --filename1 /output1.txt --filename2 /output2.txt --key_offset 0.1 2> /error.txt