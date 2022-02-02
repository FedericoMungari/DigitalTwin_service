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

while True:

	try:

		seed(14)

		# JOINTS
		p1 = [-2.171, -1.45, 0.102, -2.333, 0.859, 1.45]
		p2 = [-1.405,-0.481,-0.882,-1.145,0.555,-0.833]
		p3 = [1.611, -0.938, -0.461, -0.261, -0.131, 1.504]
		p4 = [0.918, -0.958, 0.625, 2.252, -0.641, 0.145]
		p5 = [2.287, 0.318, -0.831, 2.521, -0.241, 1.971]
		p6 = [-2.271, 0.325, 1.063, 2.321, 1.667, 2.175]	
		p7 = [-0.781, -1.265, -0.065, -1.647, -0.059, -0.541]
		p8 = [-1.873, -1.475, -0.419, 1.282, 0.399, 0.481]

		p1 = [-2.17, -1.45, 0.10, -2.33, 0.85, 1.45]
		p2 = [-1.40,-0.48,-0.88,-1.14,0.55,-0.83]
		p3 = [1.61, -0.93, -0.46, -0.26, -0.13, 1.50]
		p4 = [0.91, -0.95, 0.62, 2.25, -0.64, 0.14]
		p5 = [2.28, 0.31, -0.83, 2.52, -0.24, 1.97]
		p6 = [-2.27, 0.32, 1.06, 2.32, 1.66, 2.17]
		p7 = [-0.78, -1.26, -0.06, -1.64, -0.05, -0.54]
		p8 = [-1.87, -1.47, -0.41, 1.28, 0.39, 0.48]

		p1 = [0.290, -0.625, -0.611, -0.8, -0.142, -0.246]
		p2 = [0.041, -0.766, -0.488, -1.022, -0.288, -0.406]
		p3 = [0.552, -0.762, -0.038, -0.097, -0.395, -1.241]
		p4 = [-1.328, -1.038, -0.374, -1.112, -0.083, -0.785]
		p5 = [-0.069, -1.207, -0.169, -0.842, -0.786, -0.726]
		p6 = [-0.067, -0.510, 0.264, -0.103, -0.623, -0.466]
		p7 = [-2.006, -1.449, -0.486, 2.09, -0.402, -2.094]
		p8 = [-0.085, -1.332, -0.164, -1.670, -0.083, 0.824]
		P9 = [-0.085, -0.382, 0.159, -1.292, -0.277, -0.102]
			
		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8]

		a = 0
		b = len(p_tot)-1

		old_pos = -1
		curr_pos = -1

		# i=0

		print("date,init_position,final_position,time")

		t_start = time.time()
		t1 = time.time()

		while (time.time() - t_start < duration):

			# print(time.time()-t_start, duration, time.time()-t_start<duration)
			# print(". . . R E S T A R T . . . ")

			try:

				rospy.init_node('niryo_one_example_python_api')

				# print "--- Start"
				n = NiryoOne()

				# Calibrate robot first
				n.calibrate_auto()
				#n.calibrate_manual()
				# print "Calibration finished !\n"

				time.sleep(1)

				# Test learning mode
				n.activate_learning_mode(False)
				# print "Learning mode activated? "
				# print n.get_learning_mode()
				
				# Arm velocity
				n.set_arm_max_velocity(100)
				
				while(time.time() - t_start < duration):
					
					# print("%f,%f" %(time.time() - t_start, duration))
				
					while(1):
						_ = randint(a, b)
						if _ != old_pos:
							curr_pos = _
							break
					t1 = time.time()

					n.move_joints(p_tot[curr_pos])
					
					datestring=datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
					
					print("%s,%d,%d,%f" %(datestring,old_pos,curr_pos,time.time()-t1))

					n.wait(0)
					
					old_pos = curr_pos
			
				# print "--- End"
			
			except NiryoOneException as e:

				datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
				
				print("%s,%d,%d,%f" %(datestring,old_pos,curr_pos,time.time()-t1))
				print("ERROR - exception 1")
				print e

				time.sleep(5)

		if (time.time() - t_start > duration):
			break

	except NiryoOneException as e:

		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		
		print("%s,%d,%d,%f" %(datestring,old_pos,curr_pos,time.time()-t1))
		print("ERROR - exception 2")
		print e
		# handle exception here
		# you can also make a try/except for each command separately

		if (time.time() - t_start > duration):
			break