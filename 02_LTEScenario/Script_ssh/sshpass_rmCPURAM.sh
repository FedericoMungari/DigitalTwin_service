echo -e "\nSTEP 1"
rm ./Output/00_HostMetrics/CPUc*
rm ./Output/00_HostMetrics/resources*
rm ./Output/00_HostMetrics/RAMu*

echo -e "\nSTEP 2"
sshpass -p ros ssh ros@10.0.1.175 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.175 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.175 "rm ./resources*"
echo -e "\nSTEP 3"
sshpass -p ros ssh ros@10.0.1.188 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.188 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.188 "rm ./resources*"
echo -e "\nSTEP 4"
sshpass -p ros ssh ros@10.0.1.159 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.159 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.159 "rm ./resources*"
echo -e "\nSTEP 5"
sshpass -p ros ssh ros@10.0.1.160 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.160 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.160 "rm ./resources*"
echo -e "\nSTEP 6"
sshpass -p ros ssh ros@10.0.1.161 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.161 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.161 "rm ./resources*"
echo -e "\nSTEP 7"
sshpass -p ros ssh ros@10.0.1.162 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.162 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.162 "rm ./resources*"


read -p "Do you want to rm the files in Output folder, also?`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
echo " "
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm Output/01_host/RAMu*
	rm Output/01_host/CPUc*
	rm Output/01_host/resources*
	rm Output/02_driver/RAMu*
	rm Output/02_driver/CPUc*
	rm Output/02_driver/resources*
	rm Output/03_control/RAMu*
	rm Output/03_control/CPUc*
	rm Output/03_control/resources*
	rm Output/04_state/RAMu*
	rm Output/04_state/CPUc*
	rm Output/04_state/resources*
	rm Output/05_motionplanning/RAMu*
	rm Output/05_motionplanning/CPUc*
	rm Output/05_motionplanning/resources*
	rm Output/06_commander/RAMu*
	rm Output/06_commander/CPUc*
	rm Output/06_commander/resources*
	rm Output/07_interface/RAMu*
	rm Output/07_interface/CPUc*
	rm Output/07_interface/resources*
fi
