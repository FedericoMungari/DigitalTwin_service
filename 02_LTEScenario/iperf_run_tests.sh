#!/bin/bash

# INPUT VAR 1 : server IP
# INPUT VAR 2 : target bandwith
# INPUT VAR 3 : number of one after the other connections
# INPUT VAR 4 : duration of each connection
# INPUT VAR 5 : output interval (iperf3 i option)
# INPUT VAR 6 : tcp flag (if true, tcp, if not udp)
# INPUT VAR 7 : dualtest flag (if true, -d option is given)


# echo "Variable number 1 : "$1
# echo "Variable number 2 : "$2
# echo "Variable number 3 : "$3
# echo "Variable number 4 : "$4
# echo "Variable number 5 : "$5
# echo "Variable number 6 : "$6
# echo "Variable number 7 : "$7

SERVERIP=$1
BANDWIDTH=$2
START=1
END=$3
DURATION=$4
OUTPUTFREQ=$5

if [[ $6 ==  "true" ]]
then

	if [[ $7 ==  "true" ]]
	then

		for (( i=$START; i<=$END; i++ ))
		do
			iperf3 -c $SERVERIP -b $BANDWIDTH -t $DURATION -i $OUTPUTFREQ -d
		done

	elif [[ $7 ==  "false" ]]; then

		for (( i=$START; i<=$END; i++ ))
		do
			iperf3 -c $SERVERIP -b $BANDWIDTH -t $DURATION -i $OUTPUTFREQ
		done

	fi

elif [[ $7 ==  "false" ]]
then

	if [[ $7 ==  "true" ]]
	then

		for (( i=$START; i<=$END; i++ ))
		do
			iperf3 -c $SERVERIP -b $BANDWIDTH -t $DURATION -i $OUTPUTFREQ -d -u
		done

	elif [[ $7 ==  "false" ]]; then

		for (( i=$START; i<=$END; i++ ))
		do
			iperf3 -c $SERVERIP -b $BANDWIDTH -t $DURATION -i $OUTPUTFREQ -u
		done

	fi

fi