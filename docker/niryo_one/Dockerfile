FROM ros:kinetic

RUN apt-get update && apt-get install -q -y --no-install-recommends ros-kinetic-robot-state-publisher ros-kinetic-moveit ros-kinetic-rosbridge-suite ros-kinetic-joy ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-tf2-web-republisher python-jsonpickle lsof openssh-server && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/catkin_ws/src && cd ~/catkin_ws/src && git clone https://github.com/NiryoRobotics/niryo_one_ros.git . && mkdir /Output_script

RUN /bin/bash -c ". /opt/ros/kinetic/setup.bash && cd ~/catkin_ws && catkin_make && echo 'root:root' | chpasswd && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"

COPY ./ros_entrypoint.sh /ros_entrypoint.sh
COPY ./ros_entrypoint_VNF.sh /ros_entrypoint_VNF.sh
COPY ./desktop_rviz_simulation_cmd.launch /root/catkin_ws/src/niryo_one_bringup/.
COPY ./simulation_driver_split.launch /root/catkin_ws/src/niryo_one_bringup/.
COPY ./simulation_vnf_split.launch /root/catkin_ws/src/niryo_one_bringup/.
ENV ROS_MASTER_URI=http://master:11311
ENV ROSLAUNCH_SSH_UNKNOWN=1
ENTRYPOINT ["/ros_entrypoint_VNF.sh"]
