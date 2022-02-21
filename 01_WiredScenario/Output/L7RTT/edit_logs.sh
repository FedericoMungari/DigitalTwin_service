#!/bin/bash


for filename in /home/k8s-cloud-node/Desktop/Federico/DigitalTwin_service/01_WiredScenario/Output/L7RTT/*subscriber*; do
    [ -e "$filename" ] || continue
    newfolder="L7RTT/EDITED"
    new_filename="${filename/L7RTT/"$newfolder"}"
	echo $new_filename
    cat $filename | tr -s " " | cut -d " " -f 12 >> $new_filename
done