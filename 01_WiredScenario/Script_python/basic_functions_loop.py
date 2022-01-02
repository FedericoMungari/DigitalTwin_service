# ##
# Code taken from https://github.com/NiryoRobotics/niryo_one_ros/tree/master/niryo_one_python_api
# ##

#!/usr/bin/env python

# To use the API, copy these 4 lines on each Python file you create
from niryo_one_python_api.niryo_one_api import *
import rospy
import time
from math import radians
from random import uniform

rospy.init_node('niryo_one_example_python_api')

print "--- Start"

n = NiryoOne()

try:
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
    n.set_arm_max_velocity(50)

    for i in range(1000):

        # joint_target = [radians(uniform(0,360)), radians(uniform(0,360)), radians(uniform(0,360)), radians(uniform(0,360)), radians(uniform(0,360)), radians(uniform(0,360))]
        joint_target = [-2.171, -1.45, 0.102, -2.333, 0.859, 1.45]
        n.move_joints(joint_target)
        n.wait(1)
        joint_target = [0.0,0.0,0.0,0.0,0.0,0.0]
        n.move_joints(joint_target)
        n.wait(1)

        #End effector

        # Test gripper
        n.change_tool(TOOL_GRIPPER_2_ID)
        print "\nCurrent tool id:"
        print n.get_current_tool_id()
        n.close_gripper(TOOL_GRIPPER_2_ID,500)
        n.wait(0.2)
        n.open_gripper(TOOL_GRIPPER_2_ID,500)


except NiryoOneException as e:
    print e
    # handle exception here
    # you can also make a try/except for each command separately

print "--- End"
