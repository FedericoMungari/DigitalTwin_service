#!/bin/bash

# $1 : output file name
# $2 : machine name
# $3 : test number of iteration

default_name="machine_name"
machine_name="${2:-$default_name}"

default_count=600
count="${3:-$default_count}"

echo "iteration date time machine/VNF container name MemUsage / MemTot MemPerc CPUPerc" > "$1"

for i in $(seq $((count+1)))
# while true
do
	CPU=$(docker stats --no-stream --format "{{ .Container }} {{ .Name }} {{ .MemUsage }} {{ .MemPerc }} {{ .CPUPerc }}")
	# DATE=$(date +%s%N)
	DATE=$(date +"%Y-%m-%d %H:%M:%S")
	if ! [ -z "$CPU" ]
	then
		echo $i $DATE $machine_name $CPU >> "$1"
	fi

	# sleep 2

done