#!/bin/bash

# ######################################################################################################################################################

measurement_iteration="9000"
measurement_period="0.2"

VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162

echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     First measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600

sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_02_1.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "1.5*$measurement_iteration*$measurement_period" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_02_1.out ./Output/02_driver/


# ######################################################################################################################################################

measurement_iteration="9000"
measurement_period="0.2"


VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162

echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     Second measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_02_2.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_02_2.out ./Output/02_driver/

# ######################################################################################################################################################

measurement_iteration="6000"
measurement_period="0.3"


VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162

echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     Third measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_03_1.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_03_1.out ./Output/02_driver/
# 


# ######################################################################################################################################################

measurement_iteration="6000"
measurement_period="0.3"


VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162

echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     Fourth measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_03_2.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_03_2.out ./Output/02_driver/
# 



# ######################################################################################################################################################

measurement_iteration="3600"
measurement_period="0.5"

VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162


echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     Fifth measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_05_1.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_05_1.out ./Output/02_driver/




# ######################################################################################################################################################

measurement_iteration="3600"
measurement_period="0.5"

VM_PSW=ros
VM_USERNAME=ros

INTERFACE_MASTER_VM_IP=10.0.1.175
ROBOTCOMMANDER_VM_IP=10.0.1.188
MOTIONPLANNING_VM_IP=10.0.1.159
STATE_VM_IP=10.0.1.160
CONTROLLER_VM_IP=10.0.1.161
DRIVER_VM_IP=10.0.1.162


echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo -e "\t\t\t\t     Sixth measurement: measurement_period=$measurement_period"
echo "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

echo "Turn off and then on all the VMs. Finally wait for 10 minutes"
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sshpass -p 4646 ssh marco@10.0.1.173 "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 600


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_interface 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_command 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_motionplanning 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_state 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_control 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -u ~/resources_psutil.py $measurement_iteration $measurement_period ROS_VNF_driver 1> resources_psutil_IDLE_VM_05_2.out" 1>/dev/null &

echo "sleep"
. ./Script_startRobots/mysleep.sh $(echo "$measurement_iteration*$measurement_period+180" | bc)

sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/07_interface/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/06_commander/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$MOTIONPLANNING_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/05_motionplanning/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$STATE_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/04_state/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$CONTROLLER_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/03_control/
sshpass -p ${VM_PSW} scp ${VM_USERNAME}@$DRIVER_VM_IP:~/resources_psutil_IDLE_VM_05_2.out ./Output/02_driver/


# sshpass -p ros scp ros@10.0.1.162:~/resources_psutil_IDLE_VM_1.out ./Output/07_interface/
# sshpass -p ros scp ros@10.0.1.161:~/resources_psutil_IDLE_VM_1.out ./Output/06_commander/
# sshpass -p ros scp ros@10.0.1.160:~/resources_psutil_IDLE_VM_1.out ./Output/05_motionplanning/
# sshpass -p ros scp ros@10.0.1.159:~/resources_psutil_IDLE_VM_1.out ./Output/04_state/
# sshpass -p ros scp ros@10.0.1.188:~/resources_psutil_IDLE_VM_1.out ./Output/03_control/
# sshpass -p ros scp ros@10.0.1.175:~/resources_psutil_IDLE_VM_1.out ./Output/02_driver/
