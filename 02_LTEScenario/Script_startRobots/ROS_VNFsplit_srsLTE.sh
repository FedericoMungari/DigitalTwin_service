#!/bin/bash
# First test trying to run multiple instances of the ROS stack, splitting its layers and deploying them in docker containers hosted by one VM for layer.

# This script sets up the testbed: srsEPC, srseNB, srsUE.
# Then, a bash script will be run (main code section).

# Driver
# 	VM: 10.0.4.3 (hosted by 10.0.1.44)
# 	containers: 10.2.0.0/24
# Control
# 	VM: 10.0.3.3 (hosted by 10.0.1.46)
# 	containers: 10.1.5.0/24
# State
# 	VM: 10.0.3.5 (hosted by 10.0.1.46)
# 	containers: 10.1.4.0/24
# Motion planning
# 	VM: 10.0.3.7 (hosted by 10.0.1.46)
# 	containers: 10.1.3.0/24
# Robot commander
# 	VM: 10.0.3.6 (hosted by 10.0.1.46)
# 	containers: 10.1.2.0/24
# Interface (master
# 	VM: 10.0.3.4 (hosted by 10.0.1.46)
# 	containers: 10.1.1.0/24


#### IMPORTANT!! ###
# - Check ssh fingerprint for root user for the twin machine before running

if [[ $# -eq 5 ]]; then

	# eNB network and host configuration
	ENB_IP_PRIVATE=10.0.2.1 # ptpd
	ENB_IP_LOCAL=10.0.1.44
	ENB_IP_LTE=172.16.0.1
	ENB_USER=k8s-enb-node
	ENB_PASS=k8snode

	# epc network and host configuration (==enb)
	EPC_IP_PRIVATE=$ENB_IP_PRIVATE
	EPC_IP_LOCAL=$ENB_IP_LOCAL
	EPC_IP_LTE=$ENB_IP_LTE
	EPC_USER=$ENB_USER
	EPC_PASS=$ENB_PASS

	# ue (robot driver) network and host configuration
	UE_IP_PRIVATE=10.0.2.2
	UE_IP_LOCAL=10.0.1.46
	UE_IP_LTE=172.16.0.2
	UE_PASS=4646
	UE_USER=dell46

	ROBOT_HOST_IP_PRIVATE=$UE_IP_PRIVATE
	ROBOT_HOST_IP_LOCAL=$UE_IP_LOCAL
	ROBOT_HOST_IP_LTE=$UE_IP_LTE # EDGE_GATEWAY
	ROBOT_HOST_USER=$UE_USER
	ROBOT_HOST_PASS=$UE_PASS

	EDGE_HOST_IP_PRIVATE=$ENB_IP_PRIVATE
	EDGE_HOST_IP_LOCAL=$ENB_IP_LOCAL
	EDGE_HOST_IP_LTE=$ENB_IP_LTE # ROBOT_GATEWAY
	EDGE_HOST_USER=$ENB_USER
	EDGE_HOST_PASS=$ENB_PASS

	INTERFACE_MASTER_DOCKER_SUBNET=10.1.1.0/24
	ROBOTCOMMANDER_DOCKER_SUBNET=10.1.2.0/24
	MOTIONPLANNING_DOCKER_SUBNET=10.1.3.0/24
	STATE_DOCKER_SUBNET=10.1.4.0/24
	CONTROLLER_DOCKER_SUBNET=10.1.5.0/24

	EDGE_DOCKER_SUBNET=10.1.0.0/16

	DRIVER_DOCKER_SUBNET=10.2.0.0/24

	INTERFACE_MASTER_VM_IP=10.0.3.7
	ROBOTCOMMANDER_VM_IP=10.0.3.6
	MOTIONPLANNING_VM_IP=10.0.3.5
	STATE_VM_IP=10.0.3.4
	CONTROLLER_VM_IP=10.0.3.3

	DRIVER_VM_IP=10.0.4.3
	VM_USERNAME=ros
	VM_PSW=ros

	VM_EDGE_SUBNET=10.0.3.0/24
	VM_EDGE_GW=10.0.3.1
	VM_LOCAL_SUBNET=10.0.4.0/24
	VM_LOCAL_GW=10.0.4.1

	GAIN=80

	# measurement_iteration="6000"
	# measurement_period="0.1"


	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 1: Check the number of already running VMs"
	if [[ $(VBoxManage list runningvms |  wc -l) -eq 5  && $(sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "VBoxManage list runningvms |  wc -l") -eq 1 ]]; 
		# then n_vm_running=1
		then n_vm_running=2
	else 
		n_vm_running=2
	fi

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 2: Stop prev executing VMs, and start new ones"
	if [[ n_vm_running -eq 2 ]]; then
		. ./Script_startRobots/stop_and_start_VMs.sh
	else
		echo -e "\t . . . S k i p p i n g . . ."
		echo -e "\t\tAll the VMs are already running"
	fi

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 3: Stop prev executing containers on VMs"
	# Theoretically, not need to stop the prev container, as the VMs have been restarted now.
	# echo " - I will sleep 5 secs instead of stopping containers -"
	# sleep 5
	. ./Script_startRobots/stop_prev_containers.sh

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 4: ip tunnel creation and routing"

	if [[ n_vm_running -eq 2 ]]; then
		echo -e "\n * * * iptables"
		. ./Script_startRobots/iptables_script.sh
		echo -e "\n * * * ip-tunnel"
		. ./Script_startRobots/iptunnel_script.sh
		echo -e "\n * * * routing between bridges"
		. ./Script_startRobots/routing_between_VMs_script.sh
		echo -e "\n * * * routing between VMs"
		. ./Script_startRobots/routing_between_dockerbridges_script.sh	
	else 
		echo -e "\t . . . S k i p p i n g . . ."
	fi


	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 5: Sending CPU and RAM measurement scripts to ..."
	PATH_TO_MEAS_SCRIPTS="~/Desktop/federico/DigitalTwin_service/02_LTEScenario/Script_measurements"
	# NOTE 
	# still cannot send the measurement scripts to the driver, since even if the iptunnel was istantiated, the radio link is not there.
	# Solution: send the measurement scripts to the ROBOT HOST, which will forward them to the driver VM
	echo -e "\t... the interface VM"
	echo "VM_PSW: " $VM_PSW
	echo "PATH_TO_MEAS_SCRIPTS: " $PATH_TO_MEAS_SCRIPTS
	echo "VM_USERNAME: " $VM_USERNAME
	echo "INTERFACE_MASTER_VM_IP: " $INTERFACE_MASTER_VM_IP
	echo "sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/"
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/
	echo -e "\t... the commander VM"
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/
	echo -e "\t... the motion planning VM"
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/
	echo -e "\t... the state VM"
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${VM_USERNAME}@$STATE_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${VM_USERNAME}@$STATE_VM_IP:~/
	echo -e "\t... the control VM"
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	sshpass -p ${VM_PSW} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${VM_USERNAME}@$CONTROLLER_VM_IP:~/
	echo -e "\t... the driver VM"
	sshpass -p ${ROBOT_HOST_PASS} scp ${PATH_TO_MEAS_SCRIPTS}/CPU_measurements.sh ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL:~/Desktop/ROSNiryo/
	sshpass -p ${ROBOT_HOST_PASS} scp ${PATH_TO_MEAS_SCRIPTS}/RAM_measurements.sh ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL:~/Desktop/ROSNiryo/
	sshpass -p ${ROBOT_HOST_PASS} scp ${PATH_TO_MEAS_SCRIPTS}/resources_psutil.py ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL:~/Desktop/ROSNiryo/
	sshpass -p ${ROBOT_HOST_PASS} scp ${PATH_TO_MEAS_SCRIPTS}/resources_dockerstats.sh ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL:~/Desktop/ROSNiryo/
	sshpass -p ${ROBOT_HOST_PASS} scp ${PATH_TO_MEAS_SCRIPTS}/resources_CPUtime.py ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL:~/Desktop/ROSNiryo/
	sshpass -p ${ROBOT_HOST_PASS} ssh ${ROBOT_HOST_USER}@$ROBOT_HOST_IP_LOCAL ". /home/dell46/Desktop/ROSNiryo/send_measscripts_DRIVER.sh ${VM_PSW} ${VM_USERNAME} ${DRIVER_VM_IP}"

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 6: Starting time sync services between the LTE hosts"
	echo $EPC_PASS | sudo -S ptpd -i enp3s0 -m
	sshpass -p$UE_PASS ssh -t $UE_USER@$UE_IP_LOCAL "echo $UE_PASS | sudo -S ptpd -i enp2s0 -m" &>/dev/null
	echo "Started time sync services"

		# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 7: CPU and RAM measurements with idle VM (containers were not even istantiated)"
	if false
	then
		read -p "Do you want to measure CPU consumption and RAM usage of IDLE VMs??`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
		echo " "
		# $1 : output file name
		# $2 : test number of iteration
		# $3 : sleeping time between measurements
		# $4 : machine name
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			echo -e "\t\t. . . CPU consumption and RAM usage of IDLE VMs measuring . . ."
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_interface  2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_interface 2>RAMerror.txt" 1>/dev/null  &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_command 2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_command 2>RAMerror.txt" 1>/dev/null  &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_motionplanning 2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_motionplanning 2>RAMerror.txt" 1>/dev/null  &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_state 2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_state 2>RAMerror.txt" 1>/dev/null  &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_control 2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_control 2>RAMerror.txt" 1>/dev/null  &
			sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "sh ~/CPU_measurements.sh CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') ROS_VNF_driver 2>CPUerror.txt &\
				sh ~/RAM_measurements.sh RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period ROS_VNF_driver 2>RAMerror.txt" 1>/dev/null  &
			sh ./Script_measurements/CPU_measurements.sh ./Output/00_HostMetrics/CPUconsumption_IDLE_nocontainers.out $measurement_iteration $(echo $measurement_period | tr '.' ',') LocalHost 1>/dev/null 2>CPUerror.txt &
			sh ./Script_measurements/RAM_measurements.sh ./Output/00_HostMetrics/RAMusage_IDLE_nocontainers.out $measurement_iteration $measurement_period LocalHost 1>/dev/null  2>RAMerror.txt &

			. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+20" | bc)
		else
			echo -e "\t\t. . . CPU consumption and RAM usage of IDLE VMs will not be measured . . ."
		fi
	else
	   echo -e "\t. . . s k i p p i n g \n"
	fi
	
	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 8: USRPs firmware loading... (expect 30s for each if first time)"
	echo $EPC_PASS | sudo -S pkill -9 srsepc
	docker stop srsenb &>/dev/null
	echo $ENB_PASS | sudo -S uhd_usrp_probe &>/dev/null
	echo "Local USRP ready (EPC+eNB)"
	sshpass -p$UE_PASS ssh -t $UE_USER@$UE_IP_LOCAL "echo $UE_PASS | sudo -S pkill -9 srsue  &>/dev/null" &>/dev/null
	sshpass -p$UE_PASS ssh -t $UE_USER@$UE_IP_LOCAL "echo $UE_PASS | sudo -S uhd_usrp_probe &>/dev/null" &>/dev/null
	sshpass -p$UE_PASS ssh -t $UE_USER@$UE_IP_LOCAL "docker stop srsue &>/dev/null" &>/dev/null
	echo "Remote USRP ready (UE)"

	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 9: Run the EPC"
	echo $EPC_PASS | sudo -bS srsepc >> 99LOG_epc_output.txt &
	sleep 5
	echo "EPC is now running"


	# ####################################################################################################################################
	#Start radio link
	#enb
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 10: Run the eNB"
	# sh -c "nohup docker run -t --network=host --cap-add SYS_NICE --cap-add NET_ADMIN --cap-add SYS_ADMIN --device /dev/net/tun:/dev/net/tun --device /dev/bus/usb:/dev/bus/usb -v /tmp:/tmp --rm --name srsenb srslte:20.10 srsenb --rf.tx_gain $GAIN >/dev/null 2>&1 &"
	sh -c "docker run -t --network=host --cap-add SYS_NICE --cap-add NET_ADMIN --cap-add SYS_ADMIN --device /dev/net/tun:/dev/net/tun --device /dev/bus/usb:/dev/bus/usb -v /tmp:/tmp --rm --name srsenb srslte:20.10 srsenb --rf.tx_gain $GAIN >> 99LOG_enb_output.txt 2>&1 &"
	sleep 10
	echo "eNB is now running (radio link started)"


	# ####################################################################################################################################
	# eu
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 11: Run the UE"
	#docker run -t --network='host' --cap-add NET_ADMIN --cap-add SYS_ADMIN --device /dev/net/tun:/dev/net/tun --device /dev/bus/usb:/dev/bus/usb -v /tmp:/tmp --rm --name srsue srslte:19.09 srsue --rf.tx_gain $GAIN >/dev/null &
	{
	sshpass -p$UE_PASS ssh -t $UE_USER@$UE_IP_LOCAL "echo $UE_PASS | sudo -S srsue --general.metrics_csv_enable 1 --rf.tx_gain $GAIN" >> 99LOG_ue_output.txt &
	} &> /dev/null
	sleep 15
	echo "UE is now running"


	# ####################################################################################################################################
	# eu
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 12: Bidirectional ping between eNB and UE"
	if false
	then
		echo "First brief ping from eNB to UE"
		ping -c 5 $ROBOT_HOST_IP_LTE
		echo "First brief ping from UE to eNB"
		ping -c 5 $EDGE_HOST_IP_LTE
	fi
	pingperiod=600
	echo "The UE will ping the eNB for $pingperiod seconds in background"
	sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "nohup ping -c $pingperiod $EDGE_HOST_IP_LTE &" &>/dev/null &
	echo "The eNB will ping the UE for $pingperiod seconds in background"
	(nohup ping -c $pingperiod $ROBOT_HOST_IP_LTE &) &>/dev/null


	# ####################################################################################################################################
	echo -e "\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 13: pinging"

	if false
	then
		echo -e "\n-->Starting pinging from edge to ros_interface bridge"
		ping -c 2 $(echo $INTERFACE_MASTER_DOCKER_SUBNET | cut -d"." -f1-3)".1"
		echo -e "\n-->Starting pinging from edge to ros_command bridge"
		ping -c 2 $(echo $ROBOTCOMMANDER_DOCKER_SUBNET | cut -d"." -f1-3)".1"
		echo -e "\n-->Starting pinging from edge to ros_motionplanning bridge"
		ping -c 2 $(echo $MOTIONPLANNING_DOCKER_SUBNET | cut -d"." -f1-3)".1"
		echo -e "\n-->Starting pinging from edge to ros_state bridge"
		ping -c 2 $(echo $STATE_DOCKER_SUBNET | cut -d"." -f1-3)".1"
		echo -e "\n-->Starting pinging from edge to ros_controller bridge"
		ping -c 2 $(echo $CONTROLLER_DOCKER_SUBNET | cut -d"." -f1-3)".1"
		echo -e "\n-->Starting pinging from edge to ros_driver bridge"
		ping -c 2 $(echo $DRIVER_DOCKER_SUBNET | cut -d"." -f1-3)".1"

		echo -e "\n-->Starting pinging from robot to ros_driver bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.2.0.1"
		echo -e "\n-->Starting pinging from robot to ros_controller bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.1.5.1"
		echo -e "\n-->Starting pinging from robot to ros_state bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.1.4.1"
		echo -e "\n-->Starting pinging from robot to ros_motionplanning bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.1.3.1"
		echo -e "\n-->Starting pinging from robot to ros_command bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.1.2.1"
		echo -e "\n-->Starting pinging from robot to ros_interface bridge"
		sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "ping -c 2 10.1.1.1"
	else
		echo -e "\t . . . S k i p p i n g . . ."
	fi



	# ####################################################################################################################################
	# MAIN CODE
	echo -e "\n\n* * * * * * * * * * * * * * * * * * * * * *\nSTEP 14: STARTING EXECUTING THE MAIN CODE"
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

	. ./Script_startRobots/mysleep.sh 20

fi
