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

    seed(11)

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
    p1 = [-2.17, -1.45, 0.10, -2.33, 0.85, 1.45]
    p2 = [-1.40,-0.48,-0.88,-1.14,0.55,-0.83]
    p3 = [1.61, -0.93, -0.46, -0.26, -0.13, 1.50]
    p4 = [0.91, -0.95, 0.62, 2.25, -0.64, 0.14]
    p5 = [2.28, 0.31, -0.83, 2.52, -0.24, 1.97]
    p6 = [-2.27, 0.32, 1.06, 2.32, 1.66, 2.17]
    p7 = [-0.78, -1.26, -0.06, -1.64, -0.05, -0.54]
    p8 = [-1.87, -1.47, -0.41, 1.28, 0.39, 0.48]

    # POSE
    # p1 = [-0.150, -0.238, -0.022, 1.205, 0.852, -0.012]
    # p2 = [0.037, -0.176, 0.137, -1.142, 0.905, -0.515]
    # p3 = [-0.007, 0.232, 0.070, 0.603, 1.514, 0.968]
    # p4 = [0.237, 0.334, 0.266, 2.457, -0.094,1.403]
    # p5 = [-0.113, 0.121, 0.297, 1.732, 0.313, 2.433]
    # p6 = [0.012, 0.042, 0.605, -1.103, 0.220, -3.113]
    # p7 = [0.200, -0.208, 0.016, -2.419, 1.319, -1.019]
    # p8 = [-0.052, -0.152, -0.040, -0.337, 1.141, 2.373]

    p_tot = [p1, p2, p3, p4, p5, p6, p7, p8]

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
        n.wait(0)

except NiryoOneException as e:
    print e
    # handle exception here
    # you can also make a try/except for each command separately

print "--- End"
