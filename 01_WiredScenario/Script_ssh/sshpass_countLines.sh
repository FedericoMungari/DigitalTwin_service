echo -e "\nSTEP 1"
file=$(ls -lt | grep CPUc_* | head -1 | sed "s/  */ /g" | cut -d " " -f 9)
cat $file | wc -l
file=$(ls -lt | grep RAMu_* | head -1 | sed "s/  */ /g" | cut -d " " -f 9)
cat $file | wc -l

echo -e "\nSTEP 2"
file=$(sshpass -p ros ssh ros@10.0.1.175 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.175 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.175 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.175 "cat $file | wc -l"

echo -e "\nSTEP 3"
file=$(sshpass -p ros ssh ros@10.0.1.158 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.158 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.158 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.158 "cat $file | wc -l"

echo -e "\nSTEP 4"
file=$(sshpass -p ros ssh ros@10.0.1.159 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.159 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.159 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.159 "cat $file | wc -l"

echo -e "\nSTEP 5"
file=$(sshpass -p ros ssh ros@10.0.1.160 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.160 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.160 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.160 "cat $file | wc -l"

echo -e "\nSTEP 6"
file=$(sshpass -p ros ssh ros@10.0.1.161 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.161 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.161 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.161 "cat $file | wc -l"

echo -e "\nSTEP 7"
file=$(sshpass -p ros ssh ros@10.0.1.162 "ls -lt | grep CPUc_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.162 "cat $file | wc -l"
file=$(sshpass -p ros ssh ros@10.0.1.162 "ls -lt | grep RAMu_* | head -1 | sed 's/  */ /g' | cut -d ' ' -f 9")
sshpass -p ros ssh ros@10.0.1.162 "cat $file | wc -l"
