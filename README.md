# DigitalTwin_service


*This Github Repo contains all the files that have been used to carry out an experimental evaluation of CPU and RAM consumption of a Digital Twin service.*
*The service is decomposed into VNF defined as follows:*
- **_Driver VNF**_ *: this module runs low-level functions that directly interface with the robot hardware and sensors. It is in charge of making the robot execute the commands passed, validated and processed by higher-level VNFs, and to provide them with real time context data about the status of the robot. The status sampling frequency can be configured. The Driver VNF is the only DT building block which can not be offloaded, i.e. dislocated with respect to the robot, while the remaining stack which allows the robot controlling, visualization and maintenance can be distributed;*
- **_Control VNF**_ *: it allows robot manipulation, i.e. the execution of navigation commands and/or tool selection and action, by running a hard-real-time-compatible control loop with the driver VNF, following a control frequency. The communication between control and driver VNFs must necessarily take place in real time, and therefore has strict latency constraints;*
- **_State VNF**_ *: it is in charge of computing the forward kinematic, i.e. it keeps track of multiple coordinate frames over time, e.g joint angles, and provides a high-level representation of the robot joints positions;*
- **_Motion Planning VNF**_ *: it includes most of the features and utilities of MoveIt!, the most widely used open-source software for manipulation. The MP VNF is in charge of the inverse kinematic computation. It takes as input a move command, and computes the trajectory, i.e. the series of navigation commands, with which to instruct the robot so that the movement command can be carried out. The inverse kinematic computation is associated with a high computational burden, making the Motion Planning VNF suitable to be offloaded;*
- **_Command VNF**_ *: it manages all the robot commands issued by the interface VNF, validating them and handling concurrent requests. Commands that require inverse kinematic computation e.g. \textit{move pose} commands are redirected to the motion planning VNF. Straightforward tasks are instead redirected to the control VNF. The Commander VNF finally returns to the Interface VNF potential output messages and status information;*
- **_Interface VNF**_ *: the Interface VNF provides an high-level abstraction of the entire service stack, serving as a gateway between the robot and user applications.*
*Each VNF is hosted on a dedicated VM. The Niryo One ROS stack is splitted accordingly to the prev definition. Each slice is deployed over a Docker container hosted by the corresponding VM.*

### docker
Here the docker images are defined.

### run_tests.sh
It is the main sript: it runs the VMs and a number N of robot istances (==number of containers over each VM) **[Script_startTobots** folder **]**; it measures the CPU and RAM consumption **[Script_measurements** folder **]** of IDLE and ACTIVE **[Script_python** folder **]** robots, saving the outputs on the **Output** folder.

