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

from random import randint,seed

seed(8)

name = socket.gethostbyname(socket.gethostname())
last_position = [0, 0, 0, 0, 0, 0]
moving = True
init_time = 0.0

global INPUT_DIR, OUT_PARSED_DIR

parser = argparse.ArgumentParser()
parser.add_argument('--filename1', help="name of the file in which data will be stored", type=str, default="/Output_script/"+name)
parser.add_argument('--filename2', help="name of the file in which data will be stored", type=str, default="/Output_script/"+"TARGET"+name)
parser.add_argument('--duration', help="duration in seconds of the command in loop",type=int,default=60)
parser.add_argument('--cmd_speed', help="sleep time after each command execution",type=float, default=0.020)
parser.add_argument('--key_offset',help="offset between each command",type=float,default=0.010)
args = parser.parse_args()

filename1=args.filename1
filename2=args.filename2
duration=args.duration

f1 = open(filename1, 'w')
log1 = csv.writer(f1)
log1.writerow(["timestamp", "date", "node", "latency", "joint_1", "joint_2", "joint_3", "joint_4", "joint_5", "joint_6"])

f2 = open(filename2, 'w')
log2 = csv.writer(f2)
log2.writerow(["timestamp", "date", "init_position", "final_position", "latency"])


def logging1(event, hw_timestamp, position):
	datestring=datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
	log1.writerow([int(round(time.time() * 1000000000)),
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

def logging2(old_target, new_target, elapsed):
	datestring=datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
	log2.writerow([int(round(time.time() * 1000000000)),
					datestring,\
					old_target,\
					new_target,\
					elapsed,\
					])
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
	if all(x < 0.1  for x in diff) == True:
		# print("\n\nEqual")
		if moving == True:
			# print("Moving")
	  		moving = False
	  		elapsed_time = (rtime.secs * 1000000000 + rtime.nsecs) - init_time
	  		# print(name, elapsed_time / 1000000, joint_states.position)
	  		logging1(name, elapsed_time / 1000000, joint_states.position)
	  		# print("Execution time: ", elapsed_time / 1000000, "ms")
	  	else:
	  		# print("NOT Moving")
	  		pass
	else:
		# print("\n\nNOT Equal")
		pass

def isclose(a, b, abs_tol=5e-02):
    return abs(abs(a)-abs(b)) <= abs_tol

if __name__=="__main__":
	rospy.init_node('niryo_one_example_python_api')
	# n = NiryoOne()
	# n.set_arm_max_velocity(100)
	# n.move_joints([0,0,0,0,0,0])

	# Variables
	cmd_speed = args.cmd_speed
	key_offset = args.key_offset
	position = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
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

	a = 0
	b = len(p_tot)-1

	old_pos = -1
	curr_pos = -1

	t_start = time.time()
	while(time.time() - t_start < duration):
		try:
			while(1):
				_ = randint(a, b)
				if _ != old_pos:
					curr_pos = _
					break
			t1 = rospy.Time.now()
			flag1=True
			flag2=True
			flag3=True
			# print(position)
			while (flag1 or flag2 or flag3):
				if isclose(position[0],p_tot[_][0]):
					flag1=False
				elif position[0]< p_tot[_][0]:
					position[0] += key_offset
				else: # position[0]> p_tot[_][0]:
					position[0] -= key_offset
				if isclose(position[1],p_tot[_][1]):
					flag2=False
				elif position[1]< p_tot[_][1]:
					position[1] += key_offset
				else: # position[1]> p_tot[_][1]:
					position[1] -= key_offset
				if isclose(position[2],p_tot[_][2]):
					flag3=False
				elif position[2]< p_tot[_][2]:
					position[2] += key_offset
				else: # position[2]> p_tot[_][2]:
					position[2] -= key_offset

				# print("next position defined")
				move_to_position(pub, position, cmd_speed)
				time.sleep(cmd_speed)
				if (time.time() - t_start > duration):
					break

			t2 = rospy.Time.now()
			target_elapsed_time=(t2.secs * 1000000000 + t2.nsecs)-(t1.secs * 1000000000 + t1.nsecs)
			logging2(old_pos,curr_pos,target_elapsed_time / 1000000)
		except Exception as e:
			print(e) 