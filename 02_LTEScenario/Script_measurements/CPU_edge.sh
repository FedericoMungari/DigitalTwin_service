#|/bin/bash

# $1 epc outputfile.csv
# $2 enb outputfile.csv
# $3 number of samples 
# 		--> (ex. want 10 measure samples, then $3=10)
# $4 sampling period 
# 		--> (ex. want to take a measure sample every 0.5 seconds, then $4=0.5)


pid1=$(pgrep srsepc)
pid2=$(pgrep srsenb)

top -b -n $3 -d $4 -p $pid1 >> epc_profiling.txt
top -b -n $3 -d $4 -p $pid2 >> enb_profiling.txt

echo "%CPU,%MEM" > $1 # ./epc_profiling.csv
echo "%CPU,%MEM" > $2 # ./enb_profiling.csv
cat epc_profiling.txt | grep root | tail -n+2  | tr -s " " | cut -d " " -f 9,10  | tr ',' '.'  | tr ' ' ',' >> $1
cat enb_profiling.txt | grep root | tail -n+2  | tr -s " " | cut -d " " -f 9,10  | tr ',' '.'  | tr ' ' ',' >> $2

rm epc_profiling.txt
rm enb_profiling.txt