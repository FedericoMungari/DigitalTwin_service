# ##
# Code taken from https://github.com/NiryoRobotics/niryo_one_ros/tree/master/niryo_one_python_api
# ##

#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
from math import radians
# from random import uniform
from random import randint,seed

rospy.init_node('niryo_one_example_python_api')

print "--- Start"

n = NiryoOne()

try:

    seed(160)

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

    p1 = [-2.171, -1.45, 0.102, -2.333, 0.859, 1.45]
    p2 = [-1.405,-0.481,-0.882,-1.145,0.555,-0.833]
    p3 = [1.611, -0.938, -0.461, -0.261, -0.131, 1.504]
    p4 = [0.918, -0.958, 0.625, 2.252, -0.641, 0.145]
    p5 = [2.287, 0.318, -0.831, 2.521, -0.241, 1.971]
    p6 = [-2.271, 0.325, 1.063, 2.321, 1.667, 2.175]	
    p7 = [-0.781, -1.265, -0.065, -1.647, -0.059, -0.541]
    p8 = [-1.873, -1.475, -0.419, 1.282, 0.399, 0.481]
    
    p1 = [-0.150, -0.238, -0.022, 1.205, 0.852, -0.012]
    p2 = [0.037, -0.176, 0.137, -1.142, 0.905, -0.515]
    p3 = [-0.007, 0.232, 0.070, 0.603, 1.514, 0.968]
    p4 = [0.237, 0.334, 0.266, 2.457, -0.094,1.403]
    p5 = [-0.113, 0.121, 0.297, 1.732, 0.313, 2.433]
    p6 = [0.012, 0.042, 0.605, -1.103, 0.220, -3.113]	
    p7 = [0.200, -0.208, 0.016, -2.419, 1.319, -1.019]
    p8 = [-0.052, -0.152, -0.040, -0.337, 1.141, 2.373]
    
    p_tot = [p1, p2, p3, p4, p5, p6, p7, p8]
    
    a = 0
    b = len(p_tot)-1
    curr_pos = -1

    for i in range(1000):
 
	while(1):
            _ = randint(a, b)
            if _ != curr_pos:
                curr_pos = _
                break
	t1 = time.time()
        # n.move_joints(p_tot[curr_pos])
        n.move_pose(p_tot[curr_pos][0],p_tot[curr_pos][1],p_tot[curr_pos][2],p_tot[curr_pos][3],p_tot[curr_pos][4],p_tot[curr_pos][5])
	print("%d,%f" %(i,time.time()-t1))
        n.wait(0)

except NiryoOneException as e:
    print e
    # handle exception here
    # you can also make a try/except for each command separately

print "--- End"
