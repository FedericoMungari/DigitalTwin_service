#|/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e "Illegal number of parameters\n
    		Plese, type *top* if u want to copy the top measurements from the VMs to the local host\n
    		Plese, type *psutil* if u want to copy the psutil measurements from the VMs to the local host\n
    		Plese, type *dockerstats* if u want to copy the docker stats measurements from the VMs to the local host" >&2
    exit 2
fi


if [[ $1 ==  "top" ]]; then

	echo -e "\nSTEP 1"
	echo "Copyng CPU and RAM measurements from LocalHost"
	cp ./Output/00_HostMetrics/CPUc* ./Output/01_host/
	cp ./Output/00_HostMetrics/RAMu* ./Output/01_host/

	echo -e "\nSTEP 2"
	echo "Please enter DRIVER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/02_driver/ 
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/02_driver/

	echo -e "\nSTEP 3"
	echo "Please enter CONTROLVNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/03_control/
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/03_control/

	echo -e "\nSTEP 4"
	echo "Please enter STATE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/04_state/
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/04_state/

	echo -e "\nSTEP 5"
	echo "Please enter MOTIONPLANNING_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/05_motionplanning/
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/05_motionplanning/

	echo -e "\nSTEP 6"
	echo "Please enter COMMANDER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/06_commander/
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/06_commander/

	echo -e "\nSTEP 7"
	echo "Please enter INTERFACE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./RAMu* ./Output/07_interface/
	sshpass -p ros scp ros@$input_ip:./CPUc* ./Output/07_interface/

elif [[ $1 ==  "psutil" ]]; then

	echo -e "\nSTEP 1"
	echo "Copyng CPU and RAM measurements from LocalHost"
	cp ./Output/00_HostMetrics/resources_psutil_* ./Output/01_host/

	echo -e "\nSTEP 2"
	echo "Please enter DRIVER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/02_driver/

	echo -e "\nSTEP 3"
	echo "Please enter CONTROLVNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/03_control/

	echo -e "\nSTEP 4"
	echo "Please enter STATE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/04_state/

	echo -e "\nSTEP 5"
	echo "Please enter MOTIONPLANNING_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/05_motionplanning/

	echo -e "\nSTEP 6"
	echo "Please enter COMMANDER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/06_commander/

	echo -e "\nSTEP 7"
	echo "Please enter INTERFACE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_psutil_* ./Output/07_interface/

elif [[ $1 ==  "dockerstats" ]]; then

	echo -e "\nSTEP 1"
	echo "Copyng CPU and RAM measurements from LocalHost"
	cp ./Output/00_HostMetrics/resources_dockerstats_* ./Output/01_host/

	echo -e "\nSTEP 2"
	echo "Please enter DRIVER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/02_driver/

	echo -e "\nSTEP 3"
	echo "Please enter CONTROLVNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/03_control/

	echo -e "\nSTEP 4"
	echo "Please enter STATE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/04_state/

	echo -e "\nSTEP 5"
	echo "Please enter MOTIONPLANNING_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/05_motionplanning/

	echo -e "\nSTEP 6"
	echo "Please enter COMMANDER_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/06_commander/

	echo -e "\nSTEP 7"
	echo "Please enter INTERFACE_VNF IP address: "
	read input_ip
	echo "Copyng CPU and RAM measurements from $input_ip"
	sshpass -p ros scp ros@$input_ip:./resources_dockerstats_* ./Output/07_interface/

else
    echo -e "Plese, type *top* if u want to copy the top measurements from the VMs to the local host\nPlese, type *psutil* if u want to copy the top measurements from the VMs to the local host" >&2

fi