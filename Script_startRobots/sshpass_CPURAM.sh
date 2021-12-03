echo -e "\nSTEP 1"
cp CPUc* ./Output/01_host/
cp RAMu* ./Output/01_host/
echo -e "\nSTEP 2"
sshpass -p ros scp ros@10.0.1.175:./CPUc* ./Output/02_driver/ 
sshpass -p ros scp ros@10.0.1.175:./RAMu* ./Output/02_driver/ 
echo -e "\nSTEP 3"
sshpass -p ros scp ros@10.0.1.158:./RAMu* ./Output/03_control/
sshpass -p ros scp ros@10.0.1.158:./CPUc* ./Output/03_control/
echo -e "\nSTEP 4"
sshpass -p ros scp ros@10.0.1.159:./CPUc* ./Output/04_state/
sshpass -p ros scp ros@10.0.1.159:./RAMu* ./Output/04_state/
echo -e "\nSTEP 5"
sshpass -p ros scp ros@10.0.1.160:./RAMu* ./Output/05_motionplanning/
sshpass -p ros scp ros@10.0.1.160:./CPUc* ./Output/05_motionplanning/
echo -e "\nSTEP 6"
sshpass -p ros scp ros@10.0.1.161:./CPUc* ./Output/06_commander/
sshpass -p ros scp ros@10.0.1.161:./RAMu* ./Output/06_commander/
echo -e "\nSTEP 7"
sshpass -p ros scp ros@10.0.1.162:./RAMu* ./Output/07_interface/
sshpass -p ros scp ros@10.0.1.162:./CPUc* ./Output/07_interface/
