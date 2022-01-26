#!/bin/bash

# VMs STOPPING
echo -e "\n..Stopping the robot driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "VBoxManage controlvm ROS_VNF_driver poweroff" &>/dev/null
echo -e "\n..Stopping the robot control"
VBoxManage controlvm ROS_VNF_control poweroff &>/dev/null
echo -e "\n..Stopping the robot state"
VBoxManage controlvm ROS_VNF_state poweroff &>/dev/null
echo -e "\n..Stopping the robot motion planning"
VBoxManage controlvm ROS_VNF_motionplanning poweroff &>/dev/null
echo -e "\n..Stopping the robot commander"
VBoxManage controlvm ROS_VNF_command poweroff &>/dev/null
echo -e "\n..Stopping the robot interface"
VBoxManage controlvm ROS_VNF_interface poweroff &>/dev/null

sleep 1

echo -e "\n..Stopping the robot control"
VBoxManage modifyvm ROS_VNF_control --macaddress1 080027216B67 &>/dev/null
echo -e "\n..Stopping the robot state"
VBoxManage modifyvm ROS_VNF_state --macaddress1 080027216551 &>/dev/null
echo -e "\n..Stopping the robot motion planning"
VBoxManage modifyvm ROS_VNF_motionplanning --macaddress1 080027EF7AEA &>/dev/null
echo -e "\n..Stopping the robot commander"
VBoxManage modifyvm ROS_VNF_command --macaddress1 0800271D76A6 &>/dev/null
echo -e "\n..Stopping the robot interface"
VBoxManage modifyvm ROS_VNF_interface --macaddress1 080027E65A3E &>/dev/null

# VMs STARTING
echo -e "\n..Starting the robot driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "VBoxManage startvm ROS_VNF_driver --type headless" &>/dev/null
echo -e "\n..Starting the robot control"
VBoxManage startvm ROS_VNF_control --type headless &>/dev/null
echo -e "\n..Starting the robot state"
VBoxManage startvm ROS_VNF_state --type headless &>/dev/null
echo -e "\n..Starting the robot motion planning"
VBoxManage startvm ROS_VNF_motionplanning --type headless &>/dev/null
echo -e "\n..Starting the robot commander"
VBoxManage startvm ROS_VNF_command --type headless &>/dev/null
echo -e "\n..Starting the robot interface"
VBoxManage startvm ROS_VNF_interface --type headless &>/dev/null

. ./Script_startRobots/mysleep.sh 120

echo -e "\n * * * All the VMs are now running * * *\n"
echo -e "Remove background processes and services"
