#!/bin/bash

echo "Stopping previously istantiated containers"

# echo "ROBOT_HOST_PASS: ", $ROBOT_HOST_PASS
# echo "ROBOT_HOST_USER: ", $ROBOT_HOST_USER
# echo "ROBOT_HOST_IP_LOCAL: ", $ROBOT_HOST_IP_LOCAL

# echo "VM_PSW: ", $VM_PSW
# echo "VM_USERNAME: ", $VM_USERNAME

# echo "CONTROLLER_VM_IP: ", $CONTROLLER_VM_IP
# echo "STATE_VM_IP: ", $STATE_VM_IP
# echo "MOTIONPLANNING_VM_IP: ", $MOTIONPLANNING_VM_IP
# echo "ROBOTCOMMANDER_VM_IP: ", $ROBOTCOMMANDER_VM_IP
# echo "INTERFACE_MASTER_VM_IP: ", $INTERFACE_MASTER_VM_IP

echo "stop container command on driver VM"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL ". /home/dell46/Desktop/ROSNiryo/stop_prev_containers_DRIVER.sh ${VM_PSW} ${VM_USERNAME} ${DRIVER_VM_IP}"
echo "stop container command on controller VM"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "docker container ls -a | grep robot | cut -f 1 -d ' ' | xargs -r docker rm --force &>/dev/null" &>/dev/null
echo "stop container command on state VM"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "docker container ls -a | grep robot | cut -f 1 -d ' ' | xargs -r docker rm --force &>/dev/null" &>/dev/null
echo "stop container command on motion planning VM"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "docker container ls -a | grep robot | cut -f 1 -d ' ' | xargs -r docker rm --force &>/dev/null" &>/dev/null
echo "stop container command on commander VM"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "docker container ls -a | grep robot | cut -f 1 -d ' ' | xargs -r docker rm --force &>/dev/null" &>/dev/null
echo "stop container command on interface VM"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "docker container ls -a | grep robot | cut -f 1 -d ' ' | xargs -r docker rm --force &>/dev/null" &>/dev/null
echo "Previously active robots stopped"
echo -e "\n"
