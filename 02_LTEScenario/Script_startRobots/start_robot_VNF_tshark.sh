#!/bin/bash

# Le docker network devono essere create anticipatamente su ogni VM
# 	 docker network create -o "com.docker.network.bridge.name":"ros_bridge" --subnet="10.2.0.0/24" ros_driver
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.5.0/24" ros_controller
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.4.0/24" ros_state
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.3.0/24" ros_motionplanning
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.2.0/24" ros_command
# 	 docker network create -o "com.docker.network.bridge.name"="ros_bridge" --subnet="10.1.1.0/24" ros_interface

measurement_iteration="600"
measurement_period="0.5"

NOF_ACTIVE_ROBOTS=0

declare -a Interface_IP_Set

function start_robot () {

	NOF_ACTIVE_ROBOTS=$((NOF_ACTIVE_ROBOTS+1))
	echo -e "\n\nSTEP $((16+1*(NOF_ACTIVE_ROBOTS-1))): robot activating"
	echo -e "\t -* Activating robot #$NOF_ACTIVE_ROBOTS ..."

	# echo "DRIVER VM: ip - ",$3
	# sshpass -p$1 ssh $2@$3 "docker network ls | grep ros_"
	sshpass -p$1 ssh $2@$3 "docker run -dit --rm --name driver_robot_$((NOF_ACTIVE_ROBOTS)) --hostname driver --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_driver --ip 10.2.0.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot driver"
	DRIVER_IP=10.2.0.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Diver IP: $DRIVER_IP"
	# echo " "

	# echo "CONTROL VM: ip - ",$4
	# sshpass -p$1 ssh $2@$4 "docker network ls | grep ros_"
	sshpass -p$1 ssh $2@$4 "docker run -dit --rm --name controller_robot_$((NOF_ACTIVE_ROBOTS)) --hostname control --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_controller --ip 10.1.5.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot control"
	CONTROL_IP=10.1.5.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Control IP: $CONTROL_IP"
	# echo " "

	# echo "STATE VM: ip - ",$5
	# sshpass -p$1 ssh $2@$5 "docker network ls | grep ros_"
	sshpass -p$1 ssh $2@$5 "docker run -dit --rm --name state_robot_$((NOF_ACTIVE_ROBOTS)) --hostname state --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_state --ip 10.1.4.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot state"
	STATE_IP=10.1.4.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "State IP: $STATE_IP"
	# echo " "

	# echo "MOTION PLANNING VM: ip - ",$6
	# sshpass -p$1 ssh $2@$6 "docker network ls | grep ros_"
	sshpass -p$1 ssh $2@$6 "docker run -dit --rm --name motionplanning_robot_$((NOF_ACTIVE_ROBOTS)) --hostname motion_planning --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_motionplanning --ip 10.1.3.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot motion_planning"
	MOTIONPLANNING_IP=10.1.3.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Motion planning IP: $MOTIONPLANNING_IP"
	# echo " "

	# echo "COMMANDER VM: ip - ",$7
	# sshpass -p$1 ssh $2@$7 "docker network ls | grep ros_"
	sshpass -p$1 ssh $2@$7 "docker run -dit --rm --name commander_robot_$((NOF_ACTIVE_ROBOTS))  --hostname robot_commander --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host master:10.1.1.$((NOF_ACTIVE_ROBOTS+1)) --network ros_command --ip 10.1.2.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot robot_commander"
	ROBOTCOMMANDER_IP=10.1.2.$((NOF_ACTIVE_ROBOTS+1))
	echo -e "Robot commander IP: $ROBOTCOMMANDER_IP"
	# echo " "

	sleep 5

	# echo "INTERFACE VM: ip - ",$8
	# sshpass -p$1 ssh $2@$8 "docker network ls | grep ros_"
	interface_trial=0

	if [[ $NOF_ACTIVE_ROBOTS -eq 1 ]]; then

		while [ $(sshpass -p$1 ssh $2@$8 "docker ps" | wc -l) -ne $((NOF_ACTIVE_ROBOTS+1)) ] 
		do
			interface_trial=$((interface_trial+1))
			echo "Interface: istantiation trial #$interface_trial"
			sshpass -p$1 ssh $2@$8 "docker run -dit --rm --name interfacemaster_robot_$((NOF_ACTIVE_ROBOTS)) --hostname master --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --network ros_interface --ip 10.1.1.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot interface_master"
			. ./Script_startRobots/mysleep.sh 30
		done
		INTERFACE_IP=10.1.1.$((NOF_ACTIVE_ROBOTS+1))
		echo -e "Interface commander IP:  $INTERFACE_IP"
	else
		sshpass -p$1 ssh $2@$8 "docker run -dit --rm --name interfacemaster_robot_$((NOF_ACTIVE_ROBOTS)) --hostname master --add-host driver:10.2.0.$((NOF_ACTIVE_ROBOTS+1))  --add-host control:10.1.5.$((NOF_ACTIVE_ROBOTS+1)) --add-host state:10.1.4.$((NOF_ACTIVE_ROBOTS+1)) --add-host motion_planning:10.1.3.$((NOF_ACTIVE_ROBOTS+1)) --add-host robot_commander:10.1.2.$((NOF_ACTIVE_ROBOTS+1)) --network ros_interface --ip 10.1.1.$((NOF_ACTIVE_ROBOTS+1)) -v /home/ros/Output_script/:/Output_script robot interface_master"
		INTERFACE_IP=10.1.1.$((NOF_ACTIVE_ROBOTS+1))
		echo -e "Interface commander IP:  $INTERFACE_IP"
	fi

	#  . ./Script_startRobots/mysleep.sh 20

	Interface_IP_Set+=( $INTERFACE_IP )

}


# ##########################################################################################################################################################################

# eNB network and host configuration
ENB_IP_PRIVATE=10.0.2.1; ENB_IP_LOCAL=10.0.1.44; ENB_IP_LTE=172.16.0.1; ENB_USER=k8s-enb-node; ENB_PASS=k8snode

# epc network and host configuration (==enb)
EPC_IP_PRIVATE=$ENB_IP_PRIVATE; EPC_IP_LOCAL=$ENB_IP_LOCAL; EPC_IP_LTE=$ENB_IP_LTE; EPC_USER=$ENB_USER; EPC_PASS=$ENB_PASS

# ue (robot driver) network and host configuration
UE_IP_PRIVATE=10.0.2.2; UE_IP_LOCAL=10.0.1.46; UE_IP_LTE=172.16.0.2; UE_PASS=4646; UE_USER=dell46

ROBOT_HOST_IP_PRIVATE=$UE_IP_PRIVATE; ROBOT_HOST_IP_LOCAL=$UE_IP_LOCAL; ROBOT_HOST_IP_LTE=$UE_IP_LTE; ROBOT_HOST_USER=$UE_USER; ROBOT_HOST_PASS=$UE_PASS

EDGE_HOST_IP_PRIVATE=$ENB_IP_PRIVATE; EDGE_HOST_IP_LOCAL=$ENB_IP_LOCAL; EDGE_HOST_IP_LTE=$ENB_IP_LTE; EDGE_HOST_USER=$ENB_USER; EDGE_HOST_PASS=$ENB_PASS

INTERFACE_MASTER_DOCKER_SUBNET=10.1.1.0/24; ROBOTCOMMANDER_DOCKER_SUBNET=10.1.2.0/24; MOTIONPLANNING_DOCKER_SUBNET=10.1.3.0/24; STATE_DOCKER_SUBNET=10.1.4.0/24; CONTROLLER_DOCKER_SUBNET=10.1.5.0/24; EDGE_DOCKER_SUBNET=10.1.0.0/16

DRIVER_DOCKER_SUBNET=10.2.0.0/24

INTERFACE_MASTER_VM_IP=10.0.3.6; ROBOTCOMMANDER_VM_IP=10.0.3.7; MOTIONPLANNING_VM_IP=10.0.3.5; STATE_VM_IP=10.0.3.4; CONTROLLER_VM_IP=10.0.3.3;
DRIVER_VM_IP=10.0.4.3

VM_USERNAME=ros; VM_PSW=ros

VM_EDGE_SUBNET=10.0.3.0/24; VM_EDGE_GW=10.0.3.1; VM_LOCAL_SUBNET=10.0.4.0/24; VM_LOCAL_GW=10.0.4.1; 

n=0;
# read -p $'\nPress the number of robots to start\n' key
n_robots=$1
echo -e "$n_robots robots will be istantiated\n"


# ##########################################################################################################################################################################
# Input variables

commandname=$2

IDLEmeas_flag=$4

meas_tool=$5

# ##########################################################################################################################################################################
# Start capturing with tshark
capturing_time=$(echo $n_robots*60+120 |  bc -l)
sshpass -p ${UE_PASS} scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh ${UE_USER}@$UE_IP_LOCAL:/home/dell46/Desktop/ROSNiryo/
sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Output/tshark_traces/robot_istantiation_$((n_robots))_$commandname.pcapng srs_spgw_sgi $capturing_time &
sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "sh /home/dell46/Desktop/ROSNiryo/script_tshark.sh /home/dell46/Desktop/ROSNiryo/tshark_traces/robot_istantiation_$((n_robots))_$commandname.pcapng tun_srsue $capturing_time &" &

# ##########################################################################################################################################################################

# Robot istantiation
while true; do
	# echo " "
	# echo "VM_PSW: ",$VM_PSW
	# echo "VM_USERNAME: ",$VM_USERNAME
	# echo "DRIVER_VM_IP: ",$DRIVER_VM_IP
	# echo "CONTROLLER_VM_IP: ",$CONTROLLER_VM_IP
	# echo "STATE_VM_IP: ",$STATE_VM_IP
	# echo "MOTIONPLANNING_VM_IP: ",$MOTIONPLANNING_VM_IP
	# echo "ROBOTCOMMANDER_VM_IP: ",$ROBOTCOMMANDER_VM_IP
	# echo "INTERFACE_MASTER_VM_IP: ",$INTERFACE_MASTER_VM_IP
    start_robot $VM_PSW $VM_USERNAME $DRIVER_VM_IP $CONTROLLER_VM_IP $STATE_VM_IP $MOTIONPLANNING_VM_IP $ROBOTCOMMANDER_VM_IP $INTERFACE_MASTER_VM_IP
    n=$((n+1))
    if [[ $n -eq $n_robots ]]; then
		break
    fi
done

pkill tshark
sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "pkill tshark"

echo " "
echo "* - * - * - * - * - * - * - * - * - * - * - * - * - *"
echo "          All ROBOTS have been istantiated"
echo "* - * - * - * - * - * - * - * - * - * - * - * - * - *"

. ./Script_startRobots/mysleep.sh 20


if [[ $IDLEmeas_flag ==  "IDLEYES" && $commandname ==  "NOpose" ]]
then

	echo -e "\nIDLE containers: CPU and RAM measurement --> *_IDLE_$((n_robots))containers.out"
	if [[ $meas_tool ==  "psutil" ]]; then
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_$((n_robots))containers.out" 1>/dev/null &
		sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_CPUtime.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_CPUtime_IDLE_$((n_robots))containers.out" 1>/dev/null &
		python3 -u ./Script_measurements/resources_psutil.py $measurement_iteration $measurement_period LocalHost 1> ./Output/00_HostMetrics/resources_psutil_IDLE_$((n_robots))containers.out 2> /dev/null &
		python3 -u ./Script_measurements/resources_CPUtime.py 1500 1> ./Output/00_HostMetrics/resources_psutil_CPUtime_IDLE_$((n_robots))containers.out 2> /dev/null &
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

pkill iperf3
sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "pkill iperf3"


echo -e "\n\nSTEP $((18+1*(NOF_ACTIVE_ROBOTS-1)+1)): Run python script to send move pose or joints commands to the robot"

if [[ $commandname ==  "joints" ]]; then

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between move joint commands to the robot\n' wait_between_comm
	echo "A move joint command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_joints.py

	# . ./Script_startRobots/mysleep.sh 300

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*7" | bc))/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_joints.py
		echo "Sending script_joints.py to $ipinterface"
		sshpass -p root scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_joints.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_joints.py'
		# echo "Running script.py"
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_joints.py --filename /Output_script/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		sshpass -p root ssh root@$ipinterface 'touch /prova.txt'
		(sshpass -p root ssh root@$ipinterface 'touch /prova2.txt' &)
		# sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_joints.py 1> /Output_script/02_LTE/joints/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/02_LTE/joints/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt"
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_joints.py --duration 600 1> /Output_script/02_LTE/joints/script_joints_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/02_LTE/joints/script_joints_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done

elif [[ $commandname ==  "gripper" ]]; then

	wait_between_comm=$3
	if [[ $wait_between_comm -eq 0 ]]; then
		wait_between_comm=1
	fi
	# read -p $'\nPress the waiting time between open/close gripper commands to the robot\n' wait_between_comm
	echo "An open/close gripper command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_gripper.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*7" | bc))/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_gripper.py
		echo "Sending script_gripper.py to $ipinterface"
		sshpass -p root scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_gripper.py root@$ipinterface:/
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
		sshpass -p root scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_ROSAPI.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_ROSAPI.py'
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_ROSAPI.py --cmd_speed 0.2  --duration 3000 --filename /Output_script/02_LTE/rosapi/script_rosapi_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/02_LTE/rosapi/script_rosapi_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
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
		echo "Sending script_ROSAPI_2.py to $ipinterface"
		sshpass -p root scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_ROSAPI_2.py root@$ipinterface:/
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_ROSAPI_2.py'
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_ROSAPI_2.py --cmd_speed 0.2 --duration 3000 --filename /Output_script/02_LTE/rosapi2/script_rosapi_2_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/02_LTE/rosapi2/script_rosapi_2_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
	done

else

	commandname="pose"

	wait_between_comm=$3
	# read -p $'\nPress the waiting time between move pose commands to the robot\n' wait_between_comm
	echo "A move pose command will be sent to the robots after $wait_between_comm seconds since the last movement"

	sed -i "s/n.wait(\([0-9]\+\))/n.wait($wait_between_comm)/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_pose.py

	script_running=0
	for ipinterface in "${Interface_IP_Set[@]}"
	do
		script_running=$((script_running+1))
		sed -i "s/seed(\([0-9]\+\))/seed($(echo "$script_running*7" | bc))/g" /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_pose.py
		echo "Sending script_pose.py to $ipinterface"
		sshpass -p root scp /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_python/script_pose.py root@$ipinterface:/
		# echo "Making script.py executable"
		sshpass -p root ssh root@$ipinterface 'echo "root" | sudo -S chmod +x /script_pose.py'
		# echo "Running script.py"
		#(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api && python /script_pose.py' 1> ./Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> ./Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt &)
		# (sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python /script_pose.py --filename /Output_script/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)
		(sshpass -p root ssh root@$ipinterface 'source /root/catkin_ws/devel/setup.bash && export PYTHONPATH=${PYTHONPATH}:/root/catkin_ws/src/niryo_one_python_api/src/niryo_python_api &&'"python -u /script_pose.py --duration 3000 1> /Output_script/02_LTE/pose/script_pose_output_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt 2> /Output_script/02_LTE/pose/script_pose_error_robots$((NOF_ACTIVE_ROBOTS))_freq$((wait_between_comm))_$((script_running)).txt" &)

		# &> script_output_((NOF_ACTIVE_ROBOTS)).txt
	done
fi

# Sleep before py script execution istant and measurement period
. ./Script_startRobots/mysleep.sh 20

echo -e "\n\nSTEP $((19+2*(NOF_ACTIVE_ROBOTS-1)+2)): CPU measurements and RAM usage with VM hosting active containers (python script is running)"
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
	fi

	echo -e "\t\t. . . tshark capturing with active VMs . . ."
	capturing_time=$(echo $measurement_iteration*$measurement_period |  bc -l | awk '{print int($1)}')
	if [[ $commandname ==  "joints" ]]; then
		sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Output/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng srs_spgw_sgi $capturing_time &
		sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "sh /home/dell46/Desktop/ROSNiryo/script_tshark.sh /home/dell46/Desktop/ROSNiryo/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng tun_srsue $capturing_time &" &
	elif [[ $commandname ==  "rosapi" ]]; then
		sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Output/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng srs_spgw_sgi $capturing_time &
		sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "sh /home/dell46/Desktop/ROSNiryo/script_tshark.sh /home/dell46/Desktop/ROSNiryo/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng tun_srsue $capturing_time &" &
	elif [[ $commandname ==  "rosapi2" ]]; then
		sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Output/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng srs_spgw_sgi $capturing_time &
		sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "sh /home/dell46/Desktop/ROSNiryo/script_tshark.sh /home/dell46/Desktop/ROSNiryo/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng tun_srsue $capturing_time &" &
	elif [[ $commandname ==  "pose" ]]; then
		sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_tshark/script_tshark.sh /home/k8s-enb-node/Desktop/federico/DigitalTwin_service/02_LTEScenario/Output/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng srs_spgw_sgi $capturing_time &
		sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "sh /home/dell46/Desktop/ROSNiryo/script_tshark.sh /home/dell46/Desktop/ROSNiryo/tshark_traces/robot_active_$((n_robots))_$commandname.pcapng tun_srsue $capturing_time &" &
	fi

	. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

	pkill tshark
	sshpass -p ${UE_PASS} ssh ${UE_USER}@$UE_IP_LOCAL "pkill tshark"

else
	echo -e "\t\t. . . CPU consumption and RAM usage of VMs hosting active containers will not be measured . . ."
fi

echo "     ...     **Exit from the main script execution**     ...     "
echo -e "\n\n"