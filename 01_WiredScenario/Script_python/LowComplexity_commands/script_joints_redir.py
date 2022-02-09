#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
from math import radians
# from random import uniform
from random import randint,seed
import sys

rospy.init_node('niryo_one_example_python_api')


with open(sys.argv[1], 'w') as f1:
	# with open(sys.argv[2], 'w') as f2:
	
	try:
	
		print "--- Start"
		n = NiryoOne()

		print ("Redirecting Output into ",sys.argv[1])
		original_stdout = sys.stdout
		sys.stdout = f1
		# print ("Redirecting Error into ",sys.argv[2])
		# original_stderr = sys.stderr
		# sys.stderr = f2

		seed(22)

		# Calibrate robot first
		n.calibrate_auto()
		#n.calibrate_manual()
		print "Calibration finished !\n"
	
		time.sleep(1)

		# Test learning mode
		n.activate_learning_mode(False)
		print "Learning mode activated? "
		print n.get_learning_mode()

		# Move
		n.set_arm_max_velocity(100)
	
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
			
		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8]
		
		n.move_joints(p_tot[0])
		print ("0 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 0")
		n.move_joints(p_tot[0])
		print ("0 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 0")
		n.move_joints(p_tot[0])
		
		print ("0 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 0")
		n.move_joints(p_tot[0])
		print ("0 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 0")
		n.move_joints(p_tot[0])
		print ("0 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 0")
		n.move_joints(p_tot[0])
		print ("0 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 0")
		n.move_joints(p_tot[0])
		print ("0 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 0")
		n.move_joints(p_tot[0])
		
		n.move_joints(p_tot[1])
		print ("1 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 1")
		n.move_joints(p_tot[1])
		print ("1 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 1")
		n.move_joints(p_tot[1])
		
		n.move_joints(p_tot[2])
		print ("2 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 2")
		n.move_joints(p_tot[2])
		print ("2 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 2")
		n.move_joints(p_tot[2])
	
		n.move_joints(p_tot[3])
		print ("3 --> 5")
		n.move_joints(p_tot[5])
		print ("5 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 3")
		n.move_joints(p_tot[3])
		print ("3 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 3")
		n.move_joints(p_tot[3])
		
		n.move_joints(p_tot[4])
		print ("4 --> 6")
		n.move_joints(p_tot[6])
		print ("6 --> 4")
		n.move_joints(p_tot[4])
		print ("4 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 4")
		n.move_joints(p_tot[4])
	
		n.move_joints(p_tot[5])
		print ("5 --> 7")
		n.move_joints(p_tot[7])
		print ("7 --> 5")
		n.move_joints(p_tot[5])
		
		
		a = 0
		b = len(p_tot)-1
		curr_pos = -1
		
		for i in range(2000):
		
			while(1):
				_ = randint(a, b)
				if _ != curr_pos:
					curr_pos = _
					break
		t1 = time.time()
			n.move_joints(p_tot[curr_pos])
			# n.move_pose(p_tot[curr_pos][0],p_tot[curr_pos][1],p_tot[curr_pos][2],p_tot[curr_pos][3],p_tot[curr_pos][4],p_tot[curr_pos][5])
			print("%d,%f" %(i,time.time()-t1))
			# print("%d,%f" %(i,time.time()-t1), file=f1)
			n.wait(0)
		print "--- End"
	
	except NiryoOneException as e:
		print e
		# handle exception here
		# you can also make a try/except for each command separately