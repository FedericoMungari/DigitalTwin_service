#|/bin/bash

# $1 ue outputfile.csv
# $2 number of samples 
# 		--> (ex. want 10 measure samples, then $3=10)
# $3 sampling period 
# 		--> (ex. want to take a measure sample every 0.5 seconds, then $4=0.5)


pid1=$(pgrep srsue)

top -b -n $2 -d $3 -p $pid1 >> ue_profiling.txt

echo "%CPU,%MEM" > $1 # ./ue_profiling.csv
cat ue_profiling.txt | grep root | tail -n+2  | tr -s " " | cut -d " " -f 9,10  | tr ',' '.'  | tr ' ' ',' >> $1

rm ue_profiling.txt
