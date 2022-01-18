echo -e "\nSTEP 1"
ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9
ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9

echo -e "\nSTEP 2"
sshpass -p ros ssh ros@10.0.1.175 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.175 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"

echo -e "\nSTEP 3"
sshpass -p ros ssh ros@10.0.1.158 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.158 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"

echo -e "\nSTEP 4"
sshpass -p ros ssh ros@10.0.1.159 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.159 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"

echo -e "\nSTEP 5"
sshpass -p ros ssh ros@10.0.1.160 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.160 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"

echo -e "\nSTEP 6"
sshpass -p ros ssh ros@10.0.1.161 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.161 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"

echo -e "\nSTEP 7"
sshpass -p ros ssh ros@10.0.1.162 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
sshpass -p ros ssh ros@10.0.1.162 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9"
