#!/bin/bash

# VMs STOPPING
echo -e "\n..Stopping the robot driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
sleep  2
echo -e "\n..Stopping the robot control"
VBoxManage controlvm ROS_VNF_control poweroff &>/dev/null
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
VBoxManage startvm ROS_VNF_control --type headless &>/dev/null
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
