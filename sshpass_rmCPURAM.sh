echo -e "\nSTEP 1"
rm ./CPUc*
rm ./RAMu*
echo -e "\nSTEP 2"
sshpass -p ros ssh ros@10.0.1.175 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.175 "rm ./RAMu*"
echo -e "\nSTEP 3"
sshpass -p ros ssh ros@10.0.1.158 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.158 "rm ./CPUc*"
echo -e "\nSTEP 4"
sshpass -p ros ssh ros@10.0.1.159 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.159 "rm ./RAMu*"
echo -e "\nSTEP 5"
sshpass -p ros ssh ros@10.0.1.185 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.185 "rm ./CPUc*"
echo -e "\nSTEP 6"
sshpass -p ros ssh ros@10.0.1.161 "rm ./CPUc*"
sshpass -p ros ssh ros@10.0.1.161 "rm ./RAMu*"
echo -e "\nSTEP 7"
sshpass -p ros ssh ros@10.0.1.162 "rm ./RAMu*"
sshpass -p ros ssh ros@10.0.1.162 "rm ./CPUc*"


read -p "Do you want to rm the files in Output folder, also?`echo $'\n> '`If yes, press Y or y`echo $'\n> '`" -n 1 -r
echo " "
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm Output/01_host/RAMu*
	rm Output/01_host/CPUc*
	rm Output/02_driver/RAMu*
	rm Output/02_driver/CPUc*
	rm Output/03_control/RAMu*
	rm Output/03_control/CPUc*
	rm Output/04_state/RAMu*
	rm Output/04_state/CPUc*
	rm Output/05_motionplanning/RAMu*
	rm Output/05_motionplanning/CPUc*
	rm Output/06_commander/RAMu*
	rm Output/06_commander/CPUc*
	rm Output/07_interface/RAMu*
	rm Output/07_interface/CPUc*
fi
