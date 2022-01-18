#!/bin/bash


echo 'timestamp,cpu,ram'>"prova.csv"
seq=0
echo "Taking stats in prova.csv"
end=$(($SECONDS+$1))

while [ $SECONDS -lt $end ];
do

    #echo "Taking statistics"
    cpu=0.0
    ram=0.0
    seq=$(($seq+1))   

    while read -r i
    do
        if [[ "$i" != *"CPU"* ]]; then
            #echo "line:" $i
            proc_cpu=`echo $i | awk '{print $1}'`
            #echo "proc_cpu: " $proc_cpu
            cpu=`echo $cpu + $proc_cpu | bc`
            #echo "cpu: " $cpu
            proc_ram=`echo $i | awk '{print $2}'`
            ram=`echo $ram + $proc_ram | bc`
            #name=`echo $i | awk '{print substr($0, index($0,$3))}'`
        fi
    done < <(ps aux | awk '{print $3,$4}')

    timestamp=$(date +%s%N)
    echo $timestamp,$cpu,$ram >> "prova.csv"
    
done