#!/bin/bash

default_count=10
count="${1:-$default_count}"

default_sleepingtime=1.0
sleepingtime="${2:-$def_sleepingtime}"

top -bn 1 | egrep '^%Cpu|buff/cache' > tmp2.txt
echo prova > prova.txt

top -bn $((count+1)) -d $sleepingtime | egrep '^%Cpu|buff/cache' | tail -n $(echo "$count*2" | bc) > tmp.txt

echo "iteration,measurement_period,tool,usercpu,RAMused" > top_collection.txt
i=0
while IFS= read -r line; do
	i=$((i+1))
	if [ $((i%2)) -eq 0 ];
	then
		# echo "RAM $i : $line"
		RAMused=$(echo $line | sed "s/  */ /g" | cut -d " " -f 8 | tr ',' '.')
		echo "$i,$(echo $sleepingtime | tr ',' '.'),top,$usercpu,$RAMused" >> top_collection.txt
	else
		# echo "CPU $i : $line"
		usercpu=$(echo $line | sed "s/  */ /g" | cut -d " " -f 2 | tr ',' '.')
	fi
done < tmp.txt

rm tmp.txt