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

sleepingtime_point=$(echo $sleepingtime | tr ',' '.')

top -bn 1 | egrep '^%Cpu|buff/cache' > tmp2.txt
for i in $(seq $((count+1))); do
	top -bn 1 | egrep '^%Cpu|buff/cache' >> tmp2.txt
	sleep $sleepingtime_point
done

cat tmp2.txt | tail -n $(echo "$count*2" | bc) > tmp.txt
rm tmp2.txt

# top -bn $((count+1)) -d $sleepingtime | egrep '^%Cpu|buff/cache'| tail -n $(echo "$count*2" | bc) > tmp.txt

# Process the CPUconsumption_tmp.out file, and save the desired data into $1
rm ramerror.txt 2>/dev/null
echo "iteration,measurement_period,machine/VNF,usercpu,syscpu,nicecpu,idlecpu,IOwaitcpu,HWInteruptscpu,SWInteruptscpu,stolencpu,Total(NoIdle),RAMused" > "$1"
i=0
while IFS= read -r line; do
	i=$((i+1))
	if [ $((i%2)) -eq 0 ];
	then
		# echo "RAM $i : $line"
		RAMused=$(echo $line | sed "s/  */ /g" | cut -d " " -f 8 | tr ',' '.')
		echo "$i,$sleepingtime_point,$machine_name,$usercpu,$syscpu,$nicecpu,$idlecpu,$IOwaitcpu,$HWInteruptscpu,$SWInteruptscpu,$stolencpu,$(echo "$usercpu+$syscpu+$nicecpu+$IOwaitcpu+$HWInteruptscpu+$SWInteruptscpu+$stolencpu" | bc),$RAMused" >> "$1" 2>>ramerror.txt

	else
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
	fi
done < tmp.txt

rm tmp.txt
