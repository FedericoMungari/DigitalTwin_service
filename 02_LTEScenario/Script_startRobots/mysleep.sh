#!/bin/bash

function mysleep {
	
	echo -e "\nWaiting $1 seconds"
	
	echo -ne '| ........................................ |      (0%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##...................................... |      (5%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ####.................................... |     (10%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ######.................................. |     (15%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ########................................ |     (20%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##########.............................. |     (25%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ############............................ |     (30%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##############.......................... |     (35%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ################........................ |     (40%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##################...................... |     (45%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ####################.................... |     (50%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ######################.................. |     (55%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ########################................ |     (60%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##########################.............. |     (65%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ############################............ |     (70%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##############################.......... |     (75%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ################################........ |     (80%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ##################################...... |     (85%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ####################################.... |     (90%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ######################################.. |     (95%)\r'
	sleep $(echo "$1/20" | bc)
	echo -ne '| ######################################## |    (100%)\r'
	echo -ne '\n'

}

mysleep $1