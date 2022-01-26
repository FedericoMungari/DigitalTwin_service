#!/bin/bash

# $1 : input file name
# $2 : output file name

timeinterval=1

analyzed_file=$1
echo "Analyzed file: $analyzed_file"
 
tshark -r $1 -2 -R "ip.src==10.0.3.0/24" -q -z io,stat,$timeinterval,\
"MIN(tcp.analysis.ack_rtt)tcp.analysis.ack_rtt",\
"MAX(tcp.analysis.ack_rtt)tcp.analysis.ack_rtt",\
"AVG(tcp.analysis.ack_rtt)tcp.analysis.ack_rtt",\
"tcp.analysis.retransmission",\
"frame.number",\
"MIN(tcp.window_size)tcp.window_size",\
"MAX(tcp.window_size)",\
"AVG(tcp.window_size)tcp.window_size" > tmp.txt

output_file_format="csv"
output_file_folder="tshark_traces/csv_files"
outputfile=$(echo "${analyzed_file/pcapng/"$output_file_format"}")
outputfile=$(echo "${outputfile/tshark_traces/"$output_file_folder"}")
echo "Output file: $outputfile"


echo "iteration,timeinterval_length,rtt_min,rtt_max,rtt_avg,n_frame_lost,n_frame_tx,n_bytes_lost,n_bytes_tx,frame_loss_perc,bytes_loss_perc" > "$outputfile"
i=0
read_lines=0
while IFS= read -r line
do
	if [ $read_lines -gt 18 ]; then
		rtt_min=$(echo $line | sed "s/  */ /g" | cut -d " " -f 6 | tr ',' '.')
		rtt_max=$(echo $line | sed "s/  */ /g" | cut -d " " -f 8 | tr ',' '.')
		rtt_avg=$(echo $line | sed "s/  */ /g" | cut -d " " -f 10 | tr ',' '.')
		n_frame_lost=$(echo $line | sed "s/  */ /g" | cut -d " " -f 12 | tr ',' '.')
		n_bytes_lost=$(echo $line | sed "s/  */ /g" | cut -d " " -f 14 | tr ',' '.')
		n_frame_tx=$(echo $line | sed "s/  */ /g" | cut -d " " -f 16 | tr ',' '.')
		n_bytes_tx=$(echo $line | sed "s/  */ /g" | cut -d " " -f 18 | tr ',' '.')
		frame_loss_perc=$(echo "scale=5 ; $n_frame_lost / $n_frame_tx" | bc)
		bytes_loss_perc=$(echo "scale=5 ; $n_bytes_lost / $n_bytes_tx" | bc)
		echo "$i,$timeinterval,$rtt_min,$rtt_max,$rtt_avg,$n_frame_lost,$n_frame_tx,$n_bytes_lost,$n_bytes_tx,$frame_loss_perc,$bytes_loss_perc" >> "$outputfile"
		i=$((i+1))
	fi
	read_lines=$((read_lines+1))
done < tmp.txt

rm tmp.txt