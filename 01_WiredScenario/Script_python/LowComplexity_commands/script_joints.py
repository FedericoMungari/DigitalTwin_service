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
parser.add_argument('--key_offset',help="offset between each command",type=float,default=0.010)
args = parser.parse_args()

duration=args.duration

rospy.init_node('niryo_one_example_python_api')

if True:

	try:
	
		# print "--- Start"
		n = NiryoOne()

		seed(176)

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
	
		# JOINTS
			
		position = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

		print("iteration,date,executiontime")

		positions=[]
		indeces=[]
		# back_indeces=[]

		# i=0
		# j=19
		x=[-0.11,-0.11,-0.11,0.0,0.0,0.0]
		for _ in range(21):
			x[0]=x[0]+0.01
			x[0]=round(x[0],2)
			x[1]=x[1]+0.01
			x[1]=round(x[1],2)
			x[2]=x[2]+0.01
			x[2]=round(x[2],2)
			positions.append(x[:])

			# indeces.append(i)
			# back_indeces.append(j)
			# i=i+1
			# j=j-1

		#indeces=indeces+back_indeces
		indeces=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
		
		# print(positions)
		# print(indeces)

		iterat=0
		curr_position=0

		t_start = time.time()
		
		while(time.time() - t_start < duration):

			iterat=iterat+1
			
			# print(positions[indeces[curr_position]])
			t1 = time.time()

			n.move_joints(positions[indeces[curr_position]])

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