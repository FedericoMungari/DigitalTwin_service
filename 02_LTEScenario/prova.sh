#!/bin/bash


INTERFACE_MASTER_VM_IP=10.0.3.7


filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 8')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=8 : TIMEOUT FOUND"; fi
fi

filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 9')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=9 : TIMEOUT FOUND"; fi
fi

filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 10')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=10 : TIMEOUT FOUND"; fi
fi

filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 11')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=11 : TIMEOUT FOUND"; fi
fi

filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 12')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	numb_of_occurrences=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | grep timeout | wc -l ")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=12 : filename "$filename; echo "-f=12 : numb_of_occurrences "$numb_of_occurrences; echo "-f=12 : lastline "$lastline; echo "-f=12 : TIMEOUT FOUND"; fi
fi

filename=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP 'ls -lt /home/ros/Output_script/*output* | head -n $((1+i)) | tail -1 |  cut -d " " -f 13')
if [[ ${#filename} -gt 10 ]]; then
	lastline=$(sshpass -p ros ssh ros@$INTERFACE_MASTER_VM_IP "cat '$filename' | tail -1")
	if [[ $lastline == *"timeout"* ]]; then echo "-f=13 : TIMEOUT FOUND"; fi
fi