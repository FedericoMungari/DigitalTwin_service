#!/usr/bin/env python

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.


from niryo_one_python_api.niryo_one_api import *

import rospy
import time
import datetime
import csv
from sensor_msgs.msg import JointState
import sys, select, termios, tty
import argparse
import socket

from sensor_msgs.msg import JointState
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint

name = socket.gethostbyname(socket.gethostname())
last_position = [0, 0, 0, 0, 0, 0]
moving = True
init_time = 0.0

global INPUT_DIR, OUT_PARSED_DIR

parser = argparse.ArgumentParser()
parser.add_argument('--filename', help="name of the file in which data will be stored", type=str, default="/Output_script/"+name)
parser.add_argument('--duration', help="duration in seconds of the command in loop",type=int,default=60)
parser.add_argument('--cmd_speed', help="sleep time after each command execution",type=float, default=0.020)
parser.add_argument('--key_offset',help="offset between each command",type=float,default=0.010)
args = parser.parse_args()

filename=args.filename
duration=args.duration

f = open(filename, 'w')
log = csv.writer(f)
log.writerow(["timestamp", "date", "node", "latency", "joint_1", "joint_2", "joint_3", "joint_4", "joint_5", "joint_6"])


def logging(event, hw_timestamp, position):
	datestring=datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
	log.writerow([int(round(time.time() * 1000000000)),
					datestring,\
					event,\
					hw_timestamp,\
					"{:.3f}".format(position[0]),\
					"{:.3f}".format(position[1]),\
					"{:.3f}".format(position[2]),\
					"{:.3f}".format(position[3]),\
					"{:.3f}".format(position[4]),\
					"{:.3f}".format(position[5])])
  	sys.stdout.flush()


def move_to_position(p,pos,cmd_speed):
	global moving, last_position, init_time

	rtime = rospy.Time.now()

	# Save last position command
	last_position = pos
	moving = True
	init_time = rtime.secs * 1000000000 + rtime.nsecs

	msg = JointTrajectory()
	msg.header.stamp = rtime
	msg.joint_names = ['joint_1', 'joint_2', 'joint_3', # X, Y, Z
                     'joint_4', 'joint_5', 'joint_6'] # Not supported yet

	point = JointTrajectoryPoint()
	point.positions = pos
	point.time_from_start = rospy.Duration(cmd_speed)
	msg.points = [point]
	# print("Publishing")
	p.publish(msg)

def callback_joint_states(joint_states):
	global moving, last_position, init_time

	rtime = rospy.Time.now()
	# print(last_position)
	# print(joint_states.position)
  
	# print(last_position, " : ", joint_states.position)
	diff = [abs(x1 - x2) for (x1, x2) in zip(last_position, joint_states.position)]
	# print(diff)
	# print(" ")
	if all(x < 0.01 for x in diff) == True:
		# print("\n\nEqual")
		if moving == True:
			# print("Moving")
	  		moving = False
	  		elapsed_time = (rtime.secs * 1000000000 + rtime.nsecs) - init_time
	  		print(name, elapsed_time / 1000000, joint_states.position)
	  		logging(name, elapsed_time / 1000000, joint_states.position)
	  		# print("Execution time: ", elapsed_time / 1000000, "ms")
	  	else:
	  		# print("NOT Moving")
	  		pass
	else:
		# print("\n\nNOT Equal")
		pass

if __name__=="__main__":
	rospy.init_node('niryo_one_example_python_api')
	# n = NiryoOne()
	# n.set_arm_max_velocity(100)
	# n.move_joints([0,0,0,0,0,0])




	# Variables
	cmd_speed = args.cmd_speed
	key_offset = args.key_offset
	position = [0, 0, 0, 0, 0, 0]
	last_positon = position

	

	pub = rospy.Publisher('/niryo_one_follow_joint_trajectory_controller/command',
                         JointTrajectory, queue_size=1, tcp_nodelay=True)
	# print("Waiting 2 Seconds to connect.")
	time.sleep(2)

	# Move to initial position
	# print("Waiting 2 Seconds to move to initial position...")
	# move_to_position(pub, position, cmd_speed)
	time.sleep(2)

	# Subscribe current pose, only after the initial state is set
	sub = rospy.Subscriber('/joint_states', JointState, callback_joint_states)
	time.sleep(2)
   
	

	t_start = time.time()
	while(time.time() - t_start < duration):
		try:
			for x in range(-1, -50, -1) + range(1, 50, 1):
				position[0] += (1 if x > 0 else -1) * key_offset
				position[1] += (1 if x > 0 else -1) * key_offset
				position[2] += (1 if x > 0 else -1) * key_offset
				# print("next position defined")
				move_to_position(pub, position, cmd_speed)
				time.sleep(cmd_speed)
				if (time.time() - t_start > duration):
					break
		except Exception as e:
			print(e) 