#!/bin/bash

# $1 : output file name
# $2 : interface (srs_spgw_sgi,tun_srsue)
# $3 : capturing duration

default_outputfile_name="./tshark_capture.pcapng"
outputfile_name="${1:-$default_outputfile_name}"

echo $1
echo $2
echo $3


# tshark -i $2 -f "tcp and (dst net 10.0.3.0 mask 255.255.255.0 or src net 10.0.3.0 mask 255.255.255.0 or dst net 10.2.0.0 mask 255.255.255.0 or src net 10.2.0.0 mask 255.255.255.0) " -a "duration:${3}" -l -t e -F pcapng -w $1 -q 
tshark -i $2 -a "duration:${3}" -l -t e -F pcapng -w $1 -q 
