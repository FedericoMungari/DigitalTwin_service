#!/bin/bash
# First test trying to run multiple instances of the ROS stack, splitting its layers and deploying them in docker containers hosted by one VM for layer.

# This script sets up the testbed.
# Then, a bash script will be run (main code section).

# Driver
# 	VM: 10.0.1.143 (hosted by 10.0.1.51)
# 	containers: 10.2.0.0/24
# Control
# 	VM: 10.0.3.144 (hosted by 10.0.1.51)
# 	containers: 10.1.5.0/24
# State
# 	VM: 10.0.3.145 (hosted by 10.0.1.51)
# 	containers: 10.1.4.0/24
# Motion planning
# 	VM: 10.0.3.146 (hosted by 10.0.1.51)
# 	containers: 10.1.3.0/24
# Robot commander
# 	VM: 10.0.3.147 (hosted by 10.0.1.51)
# 	containers: 10.1.2.0/24
# Interface (master
# 	VM: 10.0.3.148 (hosted by 10.0.1.51)
# 	containers: 10.1.1.0/24


#### IMPORTANT!! ###
# - Check ssh fingerprint for root user for the twin machine before running

if [[ $# -eq 5 ]]; then

	LOCAL_HOST_PASS=4646
	LOCAL_HOST_PASS=k8snode

	REMOTE_HOST_IP=10.0.1.173
	REMOTE_HOST_PASS=4646
	REMOTE_HOST_USER=marco

	INTERFACE_MASTER_DOCKER_SUBNET=10.1.1.0/24
	ROBOTCOMMANDER_DOCKER_SUBNET=10.1.2.0/24
	MOTIONPLANNING_DOCKER_SUBNET=10.1.3.0/24
	STATE_DOCKER_SUBNET=10.1.4.0/24
	CONTROLLER_DOCKER_SUBNET=10.1.5.0/24

	DRIVER_DOCKER_SUBNET=10.2.0.0/24

	EDGE_DOCKER_SUBNET=10.1.0.0/16

	INTERFACE_MASTER_VM_IP=10.0.1.162
	ROBOTCOMMANDER_VM_IP=10.0.1.161
	MOTIONPLANNING_VM_IP=10.0.1.160
	STATE_VM_IP=10.0.1.159
	CONTROLLER_VM_IP=10.0.1.188
	DRIVER_VM_IP=10.0.1.175

	VM_USERNAME=ros
	VM_PSW=ros

	# measurement_iteration="6000"
	# measurement_period="0.1"

	# ####################################################################################################################################
	echo -e "\nPreliminary setup: run ptpd"
	echo $LOCAL_HOST_PASS | sudo -S ptpd -i enp2s0 -m
	sshpass -p$REMOTE_HOST_PASS ssh -t $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ptpd -i enp3s0 -m" &>/dev/null
	echo "Started time sync services"


	# ####################################################################################################################################
	echo -e "\nSTEP 0: Check the number of already running VMs"
	if [[ $(VBoxManage list runningvms |  wc -l) -eq 4  && $(sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage list runningvms |  wc -l") -eq 2 ]]; 
		then n_vm_running=2
	else 
		n_vm_running=2
	fi

	# ####################################################################################################################################
	echo -e "\nSTEP 1: Stop prev executing VMs, and start new ones"
	if [[ n_vm_running -eq 2 ]]; then
		. ./Script_startRobots/stop_and_start_VMs.sh
	else
		echo -e "\t . . . S k i p p i n g . . ."
		echo -e "\t\tAll the VMs are already running"
	fi

	# ####################################################################################################################################
	echo -e "\nSTEP 2: Stop prev executing containers on VMs"
	# Theoretically, not need to stop the prev container, as the VMs have been restarted now.
	# echo " - I will sleep 5 secs instead of stopping containers -"
	# sleep 5
	. ./Script_startRobots/stop_prev_containers.sh

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 3: ip tunnel creation and routing"

	if [[ n_vm_running -eq 2 ]]; then
		echo -e "\n * * * iptables"
		. ./Script_startRobots/iptables_script.sh
		echo -e "\n * * * routing between bridges"
		. ./Script_startRobots/routing_between_dockerbridges_script.sh
	else 
		echo -e "\t . . . S k i p p i n g . . ."
	fi


	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 4: Sending CPU and RAM measurement scripts to ..."
	PATH_TO_L7RTT_SCRIPTS="/home/k8s-cloud-node/Desktop/Federico/DigitalTwin_service/01_WiredScenario/Script_ApplicationRTT"
	echo -e "\t... the interface VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/docker/niryo_one/Script_ApplicationRTT
	echo -e "\t... the commander VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/docker/niryo_one/Script_ApplicationRTT
	echo -e "\t... the motion planning VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/docker/niryo_one/Script_ApplicationRTT
	echo -e "\t... the state VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$STATE_VM_IP:~/docker/niryo_one/Script_ApplicationRTT
	echo -e "\t... the control VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$CONTROLLER_VM_IP:~/docker/niryo_one/Script_ApplicationRTT
	echo -e "\t... the driver VM"
	sshpass -p ${VM_PSW} scp ./Script_measurements/CPU_measurements.sh ${VM_USERNAME}@$DRIVER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/RAM_measurements.sh ${VM_USERNAME}@$DRIVER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_psutil.py ${VM_USERNAME}@$DRIVER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_dockerstats.sh ${VM_USERNAME}@$DRIVER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ./Script_measurements/resources_CPUtime.py ${VM_USERNAME}@$DRIVER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_L7RTT_SCRIPTS}/*.py ${VM_USERNAME}@$DRIVER_VM_IP:~/docker/niryo_one/Script_ApplicationRTT

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 5: CPU and RAM measurements with idle VM (containers were not even istantiated)"
	echo -e "\t. . . s k i p p i n g \n"

	# read -p "Do you want to measure CPU consumption and RAM usage of IDLE VMs??`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
	# echo " "
	# # $1 : output file name
	# # $2 : test number of iteration
	# # $3 : sleeping time between measurements
	# # $4 : machine name
	# if [[ $REPLY =~ ^[Yy]$ ]]
	# then
		# echo -e "\t\t. . . CPU consumption and RAM usage of IDLE VMs measuring . . ."
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface  2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_interface 2>RAMerror.txt" 1>/dev/null  &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command 2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_command 2>RAMerror.txt" 1>/dev/null  &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning 2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_motionplanning 2>RAMerror.txt" 1>/dev/null  &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state 2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_state 2>RAMerror.txt" 1>/dev/null  &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control 2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_control 2>RAMerror.txt" 1>/dev/null  &
		# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver 2>CPUerror.txt &\
			# sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_driver 2>RAMerror.txt" 1>/dev/null  &
		# sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost 1>/dev/null 2>CPUerror.txt &
		# sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period LocalHost 1>/dev/null  2>RAMerror.txt &

		# . ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+20" | bc)
	# else
		# echo -e "\t\t. . . CPU consumption and RAM usage of IDLE VMs will not be measured . . ."
	# fi

	# ####################################################################################################################################
	# MAIN CODE
	echo -e "\n\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 6: STARTING EXECUTING THE MAIN CODE"
	sleep 1
	echo -ne '..1 \r'
	sleep 1
	echo -ne '..1 ..2\r'
	sleep 1
	echo -ne '..1 ..2 ..3\r'
	sleep 1

	/bin/bash ./Script_startRobots/start_robot_VNF.sh $1 $2 $3 $4 $5
	# sleep 20

	echo -e "\nMAIN CODE ENDED"	

	sleep 5

	# VMs STOPPING
	# echo "..Stopping the robot driver"
	# sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "VBoxManage controlvm ROS_VNF_driver poweroff &>/dev/null" &>/dev/null
	# sleep  1
	# echo "..Stopping the robot control"
	# VBoxManage controlvm ROS_VNF_control poweroff &>/dev/null
	# sleep 1
	# echo "..Stopping the robot state"
	# VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
	# sleep 1
	# echo "..Stopping the robot motion planning"
	# VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
	# sleep 1
	# echo "..Stopping the robot commander"
	# VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
	# sleep 1
	# echo "..Stopping the robot interface"
	# VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S mv ~/Output_script/output_publisher_DL.txt ~/Output_script/output_publisher_DL_"$2"_robot"$1"_freq"$3".txt"
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S mv ~/Output_script/output_subscriber_UL.txt ~/Output_script/output_subscriber_UL_"$2"_robot"$1"_freq"$3".txt"

	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "echo $VM_PSW | sudo -S mv ~/Output_script/output_publisher_UL.txt ~/Output_script/output_publisher_UL_"$2"_robot"$1"_freq"$3".txt"
	# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "echo $VM_PSW | sudo -S mv ~/Output_script/output_subscriber_DL.txt ~/Output_script/output_subscriber_DL_"$2"_robot"$1"_freq"$3".txt"



	VBoxManage controlvm ROS_VNF_state poweroff

fi
