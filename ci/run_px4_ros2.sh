#!/bin/bash
set -e

echo "PX4 + ROS 2 TEST"

export PX4_SIM_SPEED_FACTOR=2
export ROS_DOMAIN_ID=0

# Build PX4
cd ~/workspace/PX4-Autopilot
HEADLESS=1 make px4_sitl gz_x500
#Build ROS
echo "Building ROS 2 workspace..."
source /opt/ros/humble/setup.bash
cd ~/workspace/ros2_ws
colcon build --symlink-install
#start microxrcedds
echo "Starting Micro XRCE DDS Agent..."
MicroXRCEAgent udp4 -p 8888 &
DDS_PID=$!

#start SITL
cd ~/workspace/PX4-Autopilot
HEADLESS=1 make px4_sitl gz_x500 &
PX4_PID=$!
sleep 15
source ~/workspace/ros2_ws/install/setup.bash
# confirm ros topics
ros2 topic list | tee /tmp/topics.txt
grep -q "/fmu/out/sensor_combined" /tmp/topics.txt
timeout 5 ros2 topic echo /fmu/out/sensor_combined

kill $PX4_PID $DDS_PID
echo "Basic PX4 + ROS 2 test ran succesfully"