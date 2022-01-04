#!/bin/bash

# ######################################################################################################################################################################################
# Previous tunnels deletion 
echo -e "\nOld IP tunnel deletion on the laptop hosting the edge"
echo $EDGE_HOST_PASS | sudo -S ip tunnel del rostunnel 2>/dev/null
echo -e "Old IP tunnel deletion on the laptop hosting the driver"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip tunnel del rostunnel 2>/dev/null"


# ######################################################################################################################################################################################
# EDGE HOST IP ROUTING (this host)
echo -e "\nIP tunnel definition the laptop hosting the edge"

echo $EDGE_HOST_PASS | sudo -S ip tunnel add rostunnel mode ipip remote $UE_IP_LTE local $ENB_IP_LTE
echo $EDGE_HOST_PASS | sudo -S ifconfig rostunnel $VM_EDGE_GW
echo $EDGE_HOST_PASS | sudo -S ip link set rostunnel up


# ######################################################################################################################################################################################
# ROBOT HOST IP ROUTING
echo -e "\nIP tunnel definition the laptop hosting the driver"

sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip tunnel add rostunnel mode ipip local $UE_IP_LTE remote $ENB_IP_LTE"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ifconfig rostunnel $VM_LOCAL_GW"
sshpass -p${ROBOT_HOST_PASS} ssh $ROBOT_HOST_USER@$ROBOT_HOST_IP_LOCAL "echo $ROBOT_HOST_PASS | sudo -S ip link set rostunnel up"