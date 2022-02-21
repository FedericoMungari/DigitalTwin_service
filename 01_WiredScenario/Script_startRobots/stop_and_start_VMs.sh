#!/bin/bash

# vartmp=0
# if [[ $(VBoxManage list runningvms |  wc -l) -eq 6 ]]; then vartmp=1; fi

# if [[ "$vartmp" -eq 1 ]]; then
# {

# 	echo "All the VMs are already running"

# };
# else
# {

# VMs STOPPING
echo -e "\n..Stopping the robot driver"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sleep  0
echo -e "\n..Stopping the robot control"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
sleep 0
echo -e "\n..Stopping the robot state"
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
sleep 0
echo -e "\n..Stopping the robot motion planning"
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
sleep 0
echo -e "\n..Stopping the robot commander"
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
sleep 0
echo -e "\n..Stopping the robot interface"
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sleep 1

# VMs STARTING
echo -e "\n..Starting the robot driver"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sleep  0
echo -e "\n..Starting the robot control"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
sleep 0
echo -e "\n..Starting the robot state"
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
sleep 0
echo -e "\n..Starting the robot motion planning"
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
sleep 0
echo -e "\n..Starting the robot commander"
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
sleep 0
echo -e "\n..Starting the robot interface"
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 360

# ./remove_background_processes_VM.sh $VM_PSW 
# $VM_USERNAME $DRIVER_VM_IP $CONTROLLER_VM_IP $STATE_VM_IP $MOTIONPLANNING_VM_IP $ROBOTCOMMANDER_VM_IP $INTERFACE_MASTER_VM_IP 1>/dev/null 2>/dev/null

# };
# fi

sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "rm /home/ros/printtime.out" 
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "rm /home/ros/printtime.out" 
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "rm /home/ros/printtime.out" 


sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP 'i=0; while [ $i -le 50 ]; do python3 -c "import time; print(time.time())" >> /home/ros/printtime.out; i=$(( i + 1 )); sleep 1; done & ' &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP 'i=0; while [ $i -le 50 ]; do python3 -c "import time; print(time.time())" >> /home/ros/printtime.out; i=$(( i + 1 )); sleep 1; done & ' &
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP 'i=0; while [ $i -le 50 ]; do python3 -c "import time; print(time.time())" >> /home/ros/printtime.out; i=$(( i + 1 )); sleep 1; done & ' &

echo -e "\n * * * All the VMs are now running * * *\n"
# echo -e "Time without ptpd (1)"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -c 'import time; print(time.time())'"
# echo -e "Time without ptpd (2)"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -c 'import time; print(time.time())'"
echo -e "Time without ptpd (3)"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -c 'import time; print(time.time())'"

echo "* Run ptpd"
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "echo ${VM_PSW} | sudo -S ptpd -i enp0s3 -m"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "echo ptpdone >> /home/ros/printtime.out"
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "echo ${VM_PSW} | sudo -S ptpd -i enp0s3 -m"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "echo ptpdone >> /home/ros/printtime.out"
sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "echo ${VM_PSW} | sudo -S ptpd -i enp0s3 -m"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "echo ptpdone >> /home/ros/printtime.out"

# echo -e "Time with ptpd (1)"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -c 'import time; print(time.time())'"
# echo -e "Time with ptpd (3)"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$DRIVER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$CONTROLLER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$STATE_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$MOTIONPLANNING_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$ROBOTCOMMANDER_VM_IP "python3 -c 'import time; print(time.time())'"
# sshpass -p ${VM_PSW} ssh ${VM_USERNAME}@$INTERFACE_MASTER_VM_IP "python3 -c 'import time; print(time.time())'"