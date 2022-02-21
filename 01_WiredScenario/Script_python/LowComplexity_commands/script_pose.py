#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
from math import radians
# from random import uniform
from random import randint,seed
import sys
from datetime import datetime
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--duration', help="duration in seconds of the command in loop",type=int,default=60)
args = parser.parse_args()

duration=args.duration

rospy.init_node('niryo_one_example_python_api')

iterat=0
t1 = time.time()

if True:
	
	try:

		# print "--- Start"
		n = NiryoOne()

		seed(160)

		# Calibrate robot first
		n.calibrate_auto()
		#n.calibrate_manual()
		# print "Calibration finished !\n"

		time.sleep(1)

		# Test learning mode
		n.activate_learning_mode(False)
		# print "Learning mode activated? "
		# print n.get_learning_mode()

		# Move
		n.set_arm_max_velocity(100)
		
		p1 = [0.265, -0.027, 0.367, 0.000, 0.200, -0.100]
		p2 = [0.263, -0.024, 0.372, 0.000, 0.180, -0.090]
		p3 = [0.262, -0.021, 0.377, 0.000, 0.160, -0.080]
		p4 = [0.260, -0.018, 0.382, 0.000, 0.140, -0.070]
		p5 = [0.259, -0.016, 0.388, 0.000, 0.120, -0.060]
		p6 = [0.257, -0.013, 0.393, 0.000, 0.100, -0.050]
		p7 = [0.255, -0.010, 0.398, 0.000, 0.080, -0.040]
		p8 = [0.252, -0.008, 0.403, 0.000, 0.060, -0.030]
		p9 = [0.250, -0.005, 0.408, 0.000, 0.040, -0.020]
		p10 = [0.248, -0.002, 0.413, 0.000, 0.020, -0.010]
		p11 = [0.245, 0.000, 0.417, 0.000, 0.000, 0.000]
		p12 = [0.243, 0.002, 0.422, 0.000, -0.020, 0.010]
		p13 = [0.240, 0.005, 0.427, 0.000, -0.040, 0.020]
		p14 = [0.237, 0.007, 0.432, 0.000, -0.060, 0.030]
		p15 = [0.234, 0.009, 0.437, 0.000, -0.080, 0.040]
		p16 = [0.231, 0.012, 0.442, 0.000, -0.100, 0.050]
		p17 = [0.228, 0.014, 0.446, 0.000, -0.120, 0.060]
		p18 = [0.224, 0.016, 0.451, 0.000, -0.140, 0.070]
		p19 = [0.221, 0.018, 0.456, 0.000, -0.160, 0.080]
		p20 = [0.217, 0.020, 0.460, 0.000, -0.180, 0.090]
		p21 = [0.213, 0.021, 0.465, 0.000, -0.200, 0.100]

		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]

		indeces=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]

		iterat=0
		curr_position=0

		print("iteration,date,executiontime")

		t_start = time.time()
		
		while(time.time() - t_start < duration):

			iterat=iterat+1

			t1 = time.time()

			n.move_pose(p_tot[indeces[curr_position]][0],p_tot[indeces[curr_position]][1],p_tot[indeces[curr_position]][2],\
						p_tot[indeces[curr_position]][3],p_tot[indeces[curr_position]][4],p_tot[indeces[curr_position]][5])

			t2 = time.time()
			
			datestring=datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
			print("%d,%s,%f" %(iterat,datestring,t2-t1))
			
			curr_position=curr_position+1
			if curr_position==len(indeces)-1:
				curr_position=0
			n.wait(0)

	except NiryoOneException as e:
		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		print("%d,%s,%f" %(iterat,datestring,time.time()-t1))
		print e
		# handle exception here
		# you can also make a try/except for each command separately