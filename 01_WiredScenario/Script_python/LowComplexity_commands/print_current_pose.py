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

if True:
	
	try:

		# print "--- Start"
		n = NiryoOne()


		# Calibrate robot first
		n.calibrate_auto()
		#n.calibrate_manual()
		# print "Calibration finished !\n"

		time.sleep(1)		

		t_start = time.time()
		
		while(time.time() - t_start < duration):
			curr_pose=n.get_arm_pose()
			print(curr_pose)
			print(" ")
			time.sleep(5)

		# print "--- End"

	except NiryoOneException as e:
		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		print("%d,%s,%d,%d,%f" %(i,datestring,old_pos,curr_pos,time.time()-t1))
		print e
		# handle exception here
		# you can also make a try/except for each command separately