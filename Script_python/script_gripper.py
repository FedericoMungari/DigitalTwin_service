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

    seed(27)

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

    for i in range(100000000):

	_ = randint(0, 2)
        if _ == 0:
	    n.change_tool(TOOL_GRIPPER_1_ID)
            t1 = time.time()
            n.open_gripper(TOOL_GRIPPER_1_ID,500)
	    t2 = time.time()
            n.wait(0.2)
	    t3 = time.time()
            n.close_gripper(TOOL_GRIPPER_1_ID,500)
	    print("%d,GRIPPER1,%f,%f" %(i,t2-t1,time.time()-t3))
	elif _ == 1:
	    n.change_tool(TOOL_GRIPPER_2_ID)
            t1 = time.time()
            n.open_gripper(TOOL_GRIPPER_2_ID,500)
	    t2 = time.time()
            n.wait(0.2)
	    t3 = time.time()
            n.close_gripper(TOOL_GRIPPER_2_ID,500)
	    print("%d,GRIPPER2,%f,%f" %(i,t2-t1,time.time()-t3))
	else:
	    n.change_tool(TOOL_GRIPPER_3_ID)
            t1 = time.time()
            n.open_gripper(TOOL_GRIPPER_3_ID,500)
	    t2 = time.time()
            n.wait(0.2)
	    t3 = time.time()
            n.close_gripper(TOOL_GRIPPER_3_ID,500)
	    print("%d,GRIPPER3,%f,%f" %(i,t2-t1,time.time()-t3))

except NiryoOneException as e:
    print e
    # handle exception here
    # you can also make a try/except for each command separately

print "--- End"
