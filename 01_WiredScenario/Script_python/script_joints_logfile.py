#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
from math import radians
from random import randint,seed
import sys
from datetime import datetime
import csv
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--filename', help="name of the file in which data will be stored", type=str, default="/Output_script/prova.csv")
args = parser.parse_args()

rospy.init_node('niryo_one_example_python_api')

filename=args.filename

f = open(filename, 'w')
log = csv.writer(f)
log.writerow(["iteration,date,init_position,final_position,time"])

def logging(eventnumb,curr_pos,old_pos,exectime):
	datestring=datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
	log.writerow([eventnumb,\
					datestring,\
					old_pos,\
					curr_pos,\
					"{:.5f}".format(exectime)])
  	sys.stdout.flush()

if True:

	try:
	
		# print "--- Start"
		n = NiryoOne()

		seed(8)

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
			
		p1 = [-0.2, 0.5, 0.1, 0.0, 0.0, 0.0]
		p2 = [-0.8, 0.1, -0.5, 0.0, 0.0, 0.0]
		p3 = [-1.8, -0.4, -0.2, 0.0, 0.0, 0.0]
		p4 = [0.0, -1.0, -0.8, 0.0, 0.0, 0.0]
		p5 = [-1.0, -0.7, -0.2, 0.0, 0.0, 0.0]
		p6 = [0.4, -1.2, 0.4, 0.0, 0.0, 0.0]
		p7 = [-0.4, 0.2, -0.7, 0.0, 0.0, 0.0]
		p8 = [-1.3, -1.5, 0.0, 0.0, 0.0, 0.0]
		p9 = [1.3, 0.3, -0.2, 0.0, 0.0, 0.0]
		p10 = [-0.8, -1.0, -0.7, 0.0, 0.0, 0.0]
			
		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10]

		# TESTING SET OF move_joints COMMANDS
		# For every poses p_i and p_j with i!=j, try to move the robot from p_i to p_j and viceversa, in order to check
		# if the pose set has been properly designed
		# Uncomment just when new poses have to be tested
		# n.move_joints(p_tot[0])
		# print ("0 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 0")
		# n.move_joints(p_tot[0])
		# print ("0 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 0")
		# n.move_joints(p_tot[0])
		
		# print ("0 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 0")
		# n.move_joints(p_tot[0])
		# print ("0 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 0")
		# n.move_joints(p_tot[0])
		# print ("0 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 0")
		# n.move_joints(p_tot[0])
		# print ("0 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 0")
		# n.move_joints(p_tot[0])
		# print ("0 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 0")
		# n.move_joints(p_tot[0])
		
		# n.move_joints(p_tot[1])
		# print ("1 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 1")
		# n.move_joints(p_tot[1])
		# print ("1 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 1")
		# n.move_joints(p_tot[1])
		
		# n.move_joints(p_tot[2])
		# print ("2 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 2")
		# n.move_joints(p_tot[2])
		# print ("2 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 2")
		# n.move_joints(p_tot[2])
	
		# n.move_joints(p_tot[3])
		# print ("3 --> 5")
		# n.move_joints(p_tot[5])
		# print ("5 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 3")
		# n.move_joints(p_tot[3])
		# print ("3 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 3")
		# n.move_joints(p_tot[3])
		
		# n.move_joints(p_tot[4])
		# print ("4 --> 6")
		# n.move_joints(p_tot[6])
		# print ("6 --> 4")
		# n.move_joints(p_tot[4])
		# print ("4 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 4")
		# n.move_joints(p_tot[4])
	
		# n.move_joints(p_tot[5])
		# print ("5 --> 7")
		# n.move_joints(p_tot[7])
		# print ("7 --> 5")
		# n.move_joints(p_tot[5])
		
		
		a = 0
		b = len(p_tot)-1
		old_pos = -1
		curr_pos = -1

		# print("iteration,date,init_position,final_position,time")
		
		for i in range(100000):
		
			while(1):
				_ = randint(a, b)
				if _ != old_pos:
					curr_pos = _
					break
			t1 = time.time()
			n.move_joints(p_tot[curr_pos])
			# n.move_pose(p_tot[curr_pos][0],p_tot[curr_pos][1],p_tot[curr_pos][2],p_tot[curr_pos][3],p_tot[curr_pos][4],p_tot[curr_pos][5])
			datestring=datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
			# print("%d,%s,%d,%d,%f" %(i,datestring,old_pos,curr_pos,time.time()-t1))
			# print("%d,%f" %(i,time.time()-t1), file=f1)
			logging(i,curr_pos,old_pos,time.time()-t1)
			n.wait(0)
			old_pos = curr_pos
	
		print "--- End"
	
	except NiryoOneException as e:
		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		print("%d,%s,%d,%d,%f" %(i,datestring,old_pos,curr_pos,time.time()-t1))
		print e
		# handle exception here
		# you can also make a try/except for each command separately