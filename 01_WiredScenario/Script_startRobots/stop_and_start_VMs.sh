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
sleep  2
echo -e "\n..Stopping the robot control"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage controlvm ROS_VNF_control poweroff" &>/dev/null
sleep 2
echo -e "\n..Stopping the robot state"
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
sleep 2
echo -e "\n..Stopping the robot motion planning"
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
sleep 2
echo -e "\n..Stopping the robot commander"
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
sleep 2
echo -e "\n..Stopping the robot interface"
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sleep 3

# VMs STARTING
echo -e "\n..Starting the robot driver"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
sleep  1
echo -e "\n..Starting the robot control"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "VBoxManage startvm ROS_VNF_control --type headless" &>/dev/null
sleep 1
echo -e "\n..Starting the robot state"
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
sleep 1
echo -e "\n..Starting the robot motion planning"
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
sleep 1
echo -e "\n..Starting the robot commander"
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
sleep 1
echo -e "\n..Starting the robot interface"
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 360

echo -e "\n * * * All the VMs are now running * * *\n"
echo -e "Remove background processes and services"

# ./remove_background_processes_VM.sh $VM_PSW 
# $VM_USERNAME $DRIVER_VM_IP $CONTROLLER_VM_IP $STATE_VM_IP $MOTIONPLANNING_VM_IP $ROBOTCOMMANDER_VM_IP $INTERFACE_MASTER_VM_IP 1>/dev/null 2>/dev/null

# };
# fi
