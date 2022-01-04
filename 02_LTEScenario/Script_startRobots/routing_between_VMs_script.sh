#!/bin/bash

# ######################################################################################################################################################################################
# EDGE HOST IP ROUTING (this host)

echo -e "\nRouts on the laptop hosting the edge"
echo $EDGE_HOST_PASS | sudo -S ip route del $VM_LOCAL_SUBNET
echo $EDGE_HOST_PASS | sudo -S ip route add $VM_LOCAL_SUBNET dev rostunnel


# ######################################################################################################################################################################################
# ROBOT HOST IP ROUTING

echo -e "\nRouts on the laptop hosting the driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route del $VM_EDGE_SUBNET"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip route add $VM_EDGE_SUBNET dev rostunnel"


# ######################################################################################################################################################################################
# INTERFACE VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the interface to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_LOCAL_SUBNET &>/dev/null"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_LOCAL_SUBNET via $VM_EDGE_GW"

# ######################################################################################################################################################################################
# ROBOT COMMANDER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the robot commander to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_LOCAL_SUBNET &>/dev/null"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_LOCAL_SUBNET via $VM_EDGE_GW"

# ######################################################################################################################################################################################
# MOTION PLANNING VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the motion planning to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_LOCAL_SUBNET &>/dev/null"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_LOCAL_SUBNET via $VM_EDGE_GW"


# ######################################################################################################################################################################################
# STATE VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the state to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_LOCAL_SUBNET &>/dev/null"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_LOCAL_SUBNET via $VM_EDGE_GW"


# ######################################################################################################################################################################################
# CONTROLLER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the controller to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_LOCAL_SUBNET &>/dev/null"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_LOCAL_SUBNET via $VM_EDGE_GW"


# ######################################################################################################################################################################################
# DRIVER VM IP ROUTING
echo -e "\nAdding routes in the VM hosting the driver to reach every container and hosts"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $VM_EDGE_SUBNET &>/dev/null"
# sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $VM_EDGE_SUBNET via $VM_LOCAL_GW"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL ". /home/dell46/Desktop/ROSNiryo/iprouting_VM_DRIVER.sh ${VM_PSW} ${VM_USERNAME} ${DRIVER_VM_IP} ${VM_EDGE_SUBNET} ${VM_LOCAL_GW}"
