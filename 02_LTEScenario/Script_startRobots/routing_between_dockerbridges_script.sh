#!/bin/bash

# ######################################################################################################################################################################################
# EDGE HOST IP ROUTING (this host)

echo -e "\nRouts on the laptop hosting the edge"
echo $EDGE_HOST_PASS | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null
# echo $EDGE_HOST_PASS | sudo -S ip route del $EDGE_DOCKER_SUBNET
# echo $EDGE_HOST_PASS | sudo -S ip route add $EDGE_DOCKER_SUBNET via $VM_EDGE_GW
echo $EDGE_HOST_PASS | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null
echo $EDGE_HOST_PASS | sudo -S ip route add $DRIVER_DOCKER_SUBNET dev rostunnel &>/dev/null


# ######################################################################################################################################################################################
# ROBOT HOST IP ROUTING

echo -e "\nRouts on the laptop hosting the driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route del $EDGE_DOCKER_SUBNET" &>/dev/null
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route add $EDGE_DOCKER_SUBNET dev rostunnel" &>/dev/null
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP" &>/dev/null


# ######################################################################################################################################################################################
# INTERFACE VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the interface to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $VM_EDGE_GW" &>/dev/null

# ######################################################################################################################################################################################
# ROBOT COMMANDER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the robot commander to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $VM_EDGE_GW" &>/dev/null

# ######################################################################################################################################################################################
# MOTION PLANNING VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the motion planning to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $VM_EDGE_GW" &>/dev/null


# ######################################################################################################################################################################################
# STATE VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the state to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $VM_EDGE_GW" &>/dev/null


# ######################################################################################################################################################################################
# CONTROLLER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the controller to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $VM_EDGE_GW" &>/dev/null


# ######################################################################################################################################################################################
# DRIVER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the driver to reach every container and hosts"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_EDGE_SUBNET &>/dev/null"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_EDGE_SUBNET via $VM_LOCAL_GW"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL ". /home/dell46/Desktop/ROSNiryo/iprouting_bridges_DRIVER.sh ${VM_PSW} ${VM_USERNAME} ${DRIVER_VM_IP} ${EDGE_DOCKER_SUBNET} ${VM_LOCAL_GW} ${DRIVER_DOCKER_SUBNET}"  &>/dev/null


