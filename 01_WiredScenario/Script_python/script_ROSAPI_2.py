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

seed(96)

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

	# Save last position command
	last_position = pos
	moving = True

	msg = JointTrajectory()
	msg.joint_names = ['joint_1', 'joint_2', 'joint_3', # X, Y, Z
                     'joint_4', 'joint_5', 'joint_6'] # Not supported yet

	point = JointTrajectoryPoint()
	point.positions = pos
	# point.time_from_start = rospy.Duration(cmd_speed)
	point.time_from_start = rospy.Duration(0.01)
	msg.points = [point]
	
	rtime = rospy.Time.now()
	init_time = rtime.secs * 1000000000 + rtime.nsecs
	msg.header.stamp = rtime

	# print("Publishing")
	p.publish(msg)

def callback_joint_states(joint_states):
	global moving, last_position, init_time

	diff = [abs(x1 - x2) for (x1, x2) in zip(last_position, joint_states.position)]

	if all(x < 0.001  for x in diff) == True:

		rtime = joint_states.header.stamp

		if moving == True:
	  		moving = False
	  		elapsed_time = (rtime.secs * 1000000000 + rtime.nsecs) - init_time
	  		logging(name, elapsed_time / 1000000, joint_states.position)


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

	positions=[]
	indeces=[]
	# back_indeces=[]

	# i=0
	# j=19
	x=[-0.11,-0.11,-0.11,0.0,0.0,0.0]
	for _ in range(21):
		x[0]=x[0]+0.01
		x[0]=round(x[0],2)
		x[1]=x[1]+0.01
		x[1]=round(x[1],2)
		x[2]=x[2]+0.01
		x[2]=round(x[2],2)
		positions.append(x[:])

		# indeces.append(i)
		# back_indeces.append(j)
		# i=i+1
		# j=j-1

	#indeces=indeces+back_indeces
	indeces=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
	
	# PRINTING
	# print(positions)
	# print(indeces)
	# for ind in indeces:
	# 	print(positions[ind])

	iterat=0
	curr_position=0

	t_start = time.time()

	while(time.time() - t_start < duration):
		try:

			iterat=iterat+1

			move_to_position(pub, positions[indeces[curr_position]], cmd_speed)

			time.sleep(cmd_speed)
			if (time.time() - t_start > duration):
				break

			t2 = rospy.Time.now()

			curr_position=curr_position+1
			if curr_position==len(indeces):
				curr_position=0

		except Exception as e:
			print(e) 