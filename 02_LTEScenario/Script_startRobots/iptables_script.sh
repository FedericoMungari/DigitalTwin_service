#!/bin/bash

# ######################################################################################################################################################################################
# IPTABLE

# echo $REMOTE_HOST_PASS
# echo $REMOTE_HOST_USER
# echo $REMOTE_HOST_IP

echo -e "\niptables command on the every VM and host"

echo "iptable command on interface VM : add"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
echo "iptable command on interface VM : rm"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null

echo "iptable command on commander VM : add"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
echo "iptable command on commander VM : rm"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null

echo "iptable command on motion planning VM : add"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null"
echo "iptable command on motion planning VM : rm"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null

echo "iptable command on state VM : add"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
echo "iptable command on state VM : rm"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null

echo "iptable command on controller VM : add"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
echo "iptable command on controller VM : rm"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null

# echo "iptable command on driver VM : add"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
# echo "iptable command on driver VM : rm"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null" &>/dev/null
# echo "iptable command on driver VM"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL ". /home/dell46/Desktop/ROSNiryo/iptables_DRIVER.sh ${VM_PSW} ${VM_USERNAME} ${DRIVER_VM_IP}"

echo "iptable command on ROBOT HOST : add"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null"
echo "iptable command on ROBOT HOST : rm"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null"

echo "iptable command on EDGE HOST : add"
echo $EDGE_HOST_PASS | sudo -S iptables -D DOCKER-USER -j ACCEPT &>/dev/null
echo "iptable command on EDGE HOST : rm"
echo $EDGE_HOST_PASS | sudo -S iptables -I DOCKER-USER -j ACCEPT &>/dev/null