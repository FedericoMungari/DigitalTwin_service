#!/bin/bash

# How to call this function:
#./remove_background_processes_VM.sh $VM_PSW \
#									$VM_USERNAME \
#									$DRIVER_VM_IP \
#									$CONTROLLER_VM_IP \
#									$STATE_VM_IP \
#									$MOTIONPLANNING_VM_IP \
#									$ROBOTCOMMANDER_VM_IP \
#									$INTERFACE_MASTER_VM_IP

sshpass -p$1 ssh $2@$3 "echo $1 | sudo -S apt remove lvm2 -y --purge;\
						echo $1 | sudo -S apt remove at -y --purge;\
						echo $1 | sudo -S apt remove snapd -y --purge;\
						echo $1 | sudo -S apt remove lxcfs -y --purge;\
						echo $1 | sudo -S apt remove mdadm -y --purge;\
						echo $1 | sudo -S apt remove open-iscsi -y --purge;\
						echo $1 | sudo -S apt remove accountsservice -y --purge;\
						echo $1 | sudo -S apt remove policykit-1 -y --purge;\
						echo $1 | sudo -S apt autoremove;\
						echo $1 | sudo -S systemctl stop cron;\
						echo $1 | sudo -S systemctl disable cron;\
						echo $1 | sudo -S pkill /sbin/init"
sshpass -p$1 ssh $2@$4 "echo $1 | sudo -S apt remove lvm2 -y --purge;\
						echo $1 | sudo -S apt remove at -y --purge;\
						echo $1 | sudo -S apt remove snapd -y --purge;\
						echo $1 | sudo -S apt remove lxcfs -y --purge;\
						echo $1 | sudo -S apt remove mdadm -y --purge;\
						echo $1 | sudo -S apt remove open-iscsi -y --purge;\
						echo $1 | sudo -S apt remove accountsservice -y --purge;\
						echo $1 | sudo -S apt remove policykit-1 -y --purge;\
						echo $1 | sudo -S apt autoremove;\
						echo $1 | sudo -S systemctl stop cron;\
						echo $1 | sudo -S systemctl disable cron;\
						echo $1 | sudo -S pkill /sbin/init"
sshpass -p$1 ssh $2@$5 "echo $1 | sudo -S apt remove lvm2 -y --purge;\
						echo $1 | sudo -S apt remove at -y --purge;\
						echo $1 | sudo -S apt remove snapd -y --purge;\
						echo $1 | sudo -S apt remove lxcfs -y --purge;\
						echo $1 | sudo -S apt remove mdadm -y --purge;\
						echo $1 | sudo -S apt remove open-iscsi -y --purge;\
						echo $1 | sudo -S apt remove accountsservice -y --purg;\e
						echo $1 | sudo -S apt remove policykit-1 -y --purge;\
						echo $1 | sudo -S apt autoremove;\
						echo $1 | sudo -S systemctl stop cron;\
						echo $1 | sudo -S systemctl disable cron;\
						echo $1 | sudo -S pkill /sbin/init"
sshpass -p$1 ssh $2@$6 "echo $1 | sudo -S apt remove lvm2 -y --purge;\
						echo $1 | sudo -S apt remove at -y --purge;\
						echo $1 | sudo -S apt remove snapd -y --purge;\
						echo $1 | sudo -S apt remove lxcfs -y --purge;\
						echo $1 | sudo -S apt remove mdadm -y --purge;\
						echo $1 | sudo -S apt remove open-iscsi -y --purge;\
						echo $1 | sudo -S apt remove accountsservice -y --purge;\
						echo $1 | sudo -S apt remove policykit-1 -y --purge;\
						echo $1 | sudo -S apt autoremove;\
						echo $1 | sudo -S systemctl stop cron;\
						echo $1 | sudo -S systemctl disable cron;\
						echo $1 | sudo -S pkill /sbin/init"
sshpass -p$1 ssh $2@$7 "echo $1 | sudo -S apt remove lvm2 -y --purge;\
						echo $1 | sudo -S apt remove at -y --purge;\
						echo $1 | sudo -S apt remove snapd -y --purge;\
						echo $1 | sudo -S apt remove lxcfs -y --purge;\
						echo $1 | sudo -S apt remove mdadm -y --purge;\
						echo $1 | sudo -S apt remove open-iscsi -y --purge;\
						echo $1 | sudo -S apt remove accountsservice -y --purge;\
						echo $1 | sudo -S apt remove policykit-1 -y --purge;\
						echo $1 | sudo -S apt autoremove;\
						echo $1 | sudo -S systemctl stop cron;\
						echo $1 | sudo -S systemctl disable cron;\
						echo $1 | sudo -S pkill /sbin/init"