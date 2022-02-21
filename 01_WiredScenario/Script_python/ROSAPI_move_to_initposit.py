#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
import sys


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

		# Test learning mode
		n.activate_learning_mode(False)
		# print "Learning mode activated? "
		# print n.get_learning_mode()

		# Move
		n.set_arm_max_velocity(100)
			
		positions = [-0.1, -0.1, -0.1, 0.0, 0.0, 0.0]

		n.move_joints(positions)
	
	except NiryoOneException as e:
		print e
