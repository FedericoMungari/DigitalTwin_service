#!/bin/bash

# $1 : output file name
# $2 : test number of iteration
# $3 : sleeping time between measurements
# $4 : machine name

# echo "CPU: First variable $1"
# echo "CPU: Second variable $2"
# echo "CPU: Third variable $3"
# echo "CPU: Fourth variable $4"

default_sleepingtime=1
sleepingtime="${3:-$def_sleepingtime}"

default_count=300
count="${2:-$default_count}"

default_name="machine_name"
machine_name="${4:-$default_name}"

count=$2

DATE=$(date +"%Y-%m-%d")

if [[ $1 == prova1.txt ]]; then temporaryfile=tmp1.txt; elif [[ $1 == prova2.txt ]]; then temporaryfile=tmp2.txt; else temporaryfile=tmp.txt; fi

top -bn $((count+1)) -d $sleepingtime | egrep '^%Cpu|buff/cache|top -' | tail -n $(echo "$count*3" | bc) > $temporaryfile

		
# Process the CPUconsumption_tmp.out file, and save the desired data into $1
echo "iteration,date,time,measurement_period,machine/VNF,usercpu,syscpu,nicecpu,idlecpu,IOwaitcpu,HWInteruptscpu,SWInteruptscpu,stolencpu,Total(NoIdle),RAMused" > "$1"
written_lines=0
i=0
while IFS= read -r line
do
	if [ $((i%3)) -eq 0 ]
	then
		TIME=$(echo $line | sed "s/  */ /g" | cut -d " " -f 3 | tr ',' '.')
	elif [ $((i%3)) -eq 1 ]
	then
		# echo "CPU $i : $line"
		usercpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 2 | tr ',' '.')
		syscpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 4 | tr ',' '.')
		nicecpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 6 | tr ',' '.')
		idlecpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 8 | tr ',' '.')
		IOwaitcpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 10 | tr ',' '.')
		HWInteruptscpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 12 | tr ',' '.')
		SWInteruptscpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 14 | tr ',' '.')
		stolencpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 16 | tr ',' '.')
		# echo "usercpu: $usercpu"
		# echo "syscpu: $syscpu"
		# echo "nicecpu: $nicecpu"
		# echo "idlecpu: $idlecpu"
		# echo "IOwaitcpu: $IOwaitcpu"
		# echo "HWInteruptscpu: $HWInteruptscpu"
		# echo "SWInteruptscpu: $SWInteruptscpu"
		# echo "stolencpu: $stolencpu"
	else
		# echo "RAM $i : $line"
		RAMused=$(echo $line | sed "s/  */ /g" | cut -d " " -f 8 | tr ',' '.')
		written_lines=$((written_lines+1))
		echo "$written_lines,$DATE,$TIME,$(echo $sleepingtime | tr ',' '.'),$machine_name,$usercpu,$syscpu,$nicecpu,$idlecpu,$IOwaitcpu,$HWInteruptscpu,$SWInteruptscpu,$stolencpu,$(echo "$usercpu+$syscpu+$nicecpu+$IOwaitcpu+$HWInteruptscpu+$SWInteruptscpu+$stolencpu" | bc),$RAMused" >> "$1" 2>/dev/null
	fi
	i=$((i+1))
done < $temporaryfile