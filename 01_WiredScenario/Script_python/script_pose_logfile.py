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

i=-1
t1 = time.time()

def logging(eventnumb,exectime):
	datestring=datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
	log.writerow([eventnumb,\
					datestring,\
					"{:.5f}".format(exectime)])
  	sys.stdout.flush()

if True:
	
	try:

		# rint "--- Start"
		n = NiryoOne()

		seed(80)

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
		
		p1 = [-0.150, -0.238, -0.022, 1.205, 0.852, -0.012]
		p2 = [0.037, -0.176, 0.137, -1.142, 0.905, -0.515]
		p3 = [-0.007, 0.232, 0.070, 0.603, 1.514, 0.968]
		p4 = [0.237, 0.334, 0.266, 2.457, -0.094,1.403]
		p5 = [-0.113, 0.121, 0.297, 1.732, 0.313, 2.433]
		p6 = [0.012, 0.042, 0.605, -1.103, 0.220, -3.113]	
		p7 = [0.200, -0.208, 0.016, -2.419, 1.319, -1.019]
		p8 = [-0.052, -0.152, -0.040, -0.337, 1.141, 2.373]

		# p1 = [-0.15, -0.23, -0.02, 1.20, 0.85, -0.01]
		# p2 = [0.03, -0.17, 0.13, -1.14, 0.90, -0.51]
		# p3 = [-0.00, 0.23, 0.07, 0.60, 1.51, 0.96]
		# p4 = [0.23, 0.33, 0.26, 2.45, -0.09,1.40]
		# p5 = [-0.11, 0.12, 0.29, 1.73, 0.31, 2.43]
		# p6 = [0.01, 0.04, 0.60, -1.10, 0.22, -3.11]	
		# p7 = [0.20, -0.20, 0.01, -2.41, 1.31, -1.01]
		# p8 = [-0.05, -0.15, -0.04, -0.33, 1.14, 2.37]
		
		p1 = [0.218, 0.058, 0.131, -1.441, 1.315, -0.122]
		p2 = [0.244, 0, 0.111, -2.383, 1.277, -0.953]
		p3 = [0.277, 0.169, 0.173, -1.425, 1.190, 0.451]
		p4 = [0.053, -0.240, 0.052, -2.440, 1.428, -1.877]
		p5 = [0.256, -0.033, 0.031, 2.651, 0.903, -2.191]
		p6 = [0.335, -0.024, 0.32, -0.62, 0.865, -0.16]
		p7 = [-0.055, -0.148, -0.03, 2.035, 1.193, -0.03]
		p8 = [0.251, -0.029, -0.009, -1.627, 1.454, -0.869]
		p9 = [0.319, -0.039, 0.35, -1.465, 0.29, -0.363]

		# p1 = [0.086, -0.017, 0.526, 0.0, -0.6, -0.2]
		# p2 = [0.149, -0.154, 0.319, 0.0, 0.4, -0.8]
		# p3 = [-0.068, -0.29, 0.258, 0.0, 0.6, -1.8]
		# p4 = [0.145, 0.0, 0.052, -3.141, 1.342, 3.141]
		# p5 = [0.166, 0.258, 0.167, 0.0, 0.9, -1.0]
		# p6 = [0.354, 0.15, 0.1, 0.0, 0.8, 0.4]
		# p7 = [0.171, -0.072, 0.293, 0.0, 0.5, -0.4]
		# p8 = [0.067, -0.242, -0.045, 0.0, 1.5, -1.3]
		# p9 = [0.048, 0.173, 0.432, 0.0, -0.1, 1.3]
		# p10 = [0.118, -0.122, 0.05, 3.141, 1.442, 2.342]

		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8]
		p_tot = [p1, p2, p3, p4, p5, p6, p7, p8, p9]
		# p_tot = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10]

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
			# n.move_joints(p_tot[curr_pos])
			n.move_pose(p_tot[curr_pos][0],p_tot[curr_pos][1],p_tot[curr_pos][2],p_tot[curr_pos][3],p_tot[curr_pos][4],p_tot[curr_pos][5])
			t2 = time.time()

			logging(i+1,t2-t1)
			n.wait(0)
			old_pos = curr_pos

		print "--- End"

	except NiryoOneException as e:
		datestring=datetime.now().strftime("%Y-%m-%d,%H:%M:%S")
		print("%d,%s,%f" %(i,datestring,time.time()-t1))
		print e
		# handle exception here
		# you can also make a try/except for each command separately