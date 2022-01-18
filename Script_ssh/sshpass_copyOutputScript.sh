#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e "Illegal number of parameters\nPlese, insert the INTERFACE_VNF IP address" >&2
    exit 2
fi

echo "Copying python script outputs from $1 to ./Output/Output_script/"
sshpass -p ros scp ros@$1:./Output_script/* ./Output/Output_script/
