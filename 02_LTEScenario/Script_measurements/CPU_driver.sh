#|/bin/bash

# $1 number of samples
# $2 sampling period


pid1=$(pgrep srsepc)
pid2=$(pgrep srsenb)

top -b -n $1 -d $2 -p $pid1 >> ./epc_profiling.txt
top -b -n $1 -d $2 -p $pid2 >> ./enb_profiling.txt

cat ./epc_profiling.txt | grep root | tail -n+2  | tr -s " " | cut -d " " -f 10,11  | tr ',' '.'  | tr ' ' ',' >> ./epc_profiling.csv
cat ./epc_profiling.txt | grep root | tail -n+2  | tr -s " " | cut -d " " -f 10,11  | tr ',' '.'  | tr ' ' ',' >> ./epc_profiling.csv

rm epc_profiling.txt
rm enb_profiling.txt