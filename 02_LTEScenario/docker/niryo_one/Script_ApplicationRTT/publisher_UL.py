#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String
import time
import datetime
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--duration', help="duration in seconds of the command in loop",type=int,default=60)
args = parser.parse_args()
duration=args.duration


def talker():

    init_time=time.time()

    pub = rospy.Publisher('chatter_UL', String, queue_size=10)
    rospy.init_node('talker_UL', anonymous=True)
    rate = rospy.Rate(1) # 10hz
    while ((time.time() - init_time)<duration and (not rospy.is_shutdown())):
        now=rospy.get_rostime()
        rtime=now.secs * 1000000000 + now.nsecs
        hello_str = "%d" %rtime
        print(hello_str)
        rospy.loginfo("%f" %rtime)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass