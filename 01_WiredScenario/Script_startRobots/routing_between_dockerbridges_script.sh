#!/bin/bash

# ######################################################################################################################################################################################
# INTERFACE VM IP ROUTING
echo -e "Adding routes in the VM hosting the interface to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$INTERFACE_MASTER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null" &>/dev/null

# ######################################################################################################################################################################################
# ROBOT COMMANDER VM IP ROUTING
echo -e "Adding routes in the VM hosting the robot commander to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$ROBOTCOMMANDER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null" &>/dev/null

# ######################################################################################################################################################################################
# MOTION PLANNING VM IP ROUTING
echo -e "Adding routes in the VM hosting the motion planning to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$MOTIONPLANNING_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null" &>/dev/null


# ######################################################################################################################################################################################
# STATE VM IP ROUTING
echo -e "Adding routes in the VM hosting the state to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$STATE_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null" &>/dev/null


# ######################################################################################################################################################################################
# CONTROLLER VM IP ROUTING
echo -e "Adding routes in the VM hosting the controller to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$CONTROLLER_VM_IP "echo $VM_PSW | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null" &>/dev/null


# ######################################################################################################################################################################################
# DRIVER VM IP ROUTING
echo -e "Adding routes in the VM hosting the driver to reach every container and hosts"
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null" &>/dev/null
sshpass -p${VM_PSW} ssh $VM_USERNAME@$DRIVER_VM_IP "echo $VM_PSW | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null" &>/dev/null

# ######################################################################################################################################################################################
# LOCAL HOST IP ROUTING
echo -e "Adding routes in the LOCAL HOST to reach every container and hosts"
echo $LOCAL_HOST_PASS | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route del $STATE_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route del $DRIVER_DOCKER_SUBNET &>/dev/null
echo $LOCAL_HOST_PASS | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP &>/dev/null

# ######################################################################################################################################################################################
# REMOTE HOST IP ROUTING
echo -e "Adding routes in the LOCAL HOST to reach every container and hosts"
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $INTERFACE_MASTER_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $INTERFACE_MASTER_DOCKER_SUBNET via $INTERFACE_MASTER_VM_IP" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $ROBOTCOMMANDER_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $ROBOTCOMMANDER_DOCKER_SUBNET via $ROBOTCOMMANDER_VM_IP" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $MOTIONPLANNING_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $MOTIONPLANNING_DOCKER_SUBNET via $MOTIONPLANNING_VM_IP" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $STATE_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $STATE_DOCKER_SUBNET via $STATE_VM_IP" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $CONTROLLER_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $CONTROLLER_DOCKER_SUBNET via $CONTROLLER_VM_IP" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route del $DRIVER_DOCKER_SUBNET" &>/dev/null
sshpass -p${REMOTE_HOST_PASS} ssh $REMOTE_HOST_USER@$REMOTE_HOST_IP "echo $REMOTE_HOST_PASS | sudo -S ip route add $DRIVER_DOCKER_SUBNET via $DRIVER_VM_IP" &>/dev/null