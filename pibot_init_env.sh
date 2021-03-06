#!/bin/bash

if ! [ $PIBOT_ENV_INITIALIZED ]; then
    echo "export PIBOT_ENV_INITIALIZED=1" >> ~/.bashrc
    echo "source ~/.pibotrc" >> ~/.bashrc

    #rules
    echo "setup pibot modules"
    echo " "
    sudo cp rules/pibot.rules  /etc/udev/rules.d
    sudo cp rules/rplidar.rules  /etc/udev/rules.d
    sudo cp rules/ydlidar.rules  /etc/udev/rules.d
    sudo cp rules/orbbec.rules  /etc/udev/rules.d
    echo " "
    echo "Restarting udev"
    echo ""
    sudo service udev reload
    sudo service udev restart
fi

code_name=$(lsb_release -sc)

if [ "$code_name" = "trusty" ]; then
    ros_version="indigo"
elif [ "$code_name" = "xenial" ]; then
    ros_version="kinetic"
else
    echo "PIBOT not support "$code_name
    exit
fi 

echo "source /opt/ros/${ros_version}/setup.bash" > ~/.pibotrc


#LOCAL_IP=`ifconfig eth0|grep "inet addr:"|awk -F":" '{print $2}'|awk '{print $1}'`
#LOCAL_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'`

#if [ ! ${LOCAL_IP} ]; then
#    echo "please check network"
#    exit
#fi

LOCAL_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'`
echo "LOCAL_IP=\`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print \$2}' | awk -F"/" '{print \$1}'\`" >> ~/.pibotrc

if [ ! ${LOCAL_IP} ]; then
    echo "please check network"
    exit
fi

read -p "please specify pibot model(0:apollo,1:apolloX,2:zeus,3:hera,4:hades,other for user defined):" PIBOT_MODEL_INPUT

if [ "$PIBOT_MODEL_INPUT" = "0" ]; then
    PIBOT_MODEL='apollo'
elif [ "$PIBOT_MODEL_INPUT" = "1" ]; then
    PIBOT_MODEL='apolloX'
elif [ "$PIBOT_MODEL_INPUT" = "2" ]; then
    PIBOT_MODEL='zeus'
elif [ "$PIBOT_MODEL_INPUT" = "3" ]; then
    PIBOT_MODEL='hera'
elif [ "$PIBOT_MODEL_INPUT" = "4" ]; then
    PIBOT_MODEL='hades'
else
    PIBOT_MODEL=$PIBOT_MODEL_INPUT 
fi

read -p "please specify your pibot lidar(0:rplidar,1:rplidar-a3,2:eai-x4,3:eai-g4,4:xtion,5:astra,6:kinectV1,other for user defined):" PIBOT_LIDAR_INPUT

if [ "$PIBOT_LIDAR_INPUT" = "0" ]; then
    PIBOT_LIDAR='rplidar'
elif [ "$PIBOT_LIDAR_INPUT" = "1" ]; then
    PIBOT_LIDAR='rplidar-a3'
elif [ "$PIBOT_LIDAR_INPUT" = "2" ]; then
    PIBOT_LIDAR='eai-x4'
elif [ "$PIBOT_LIDAR_INPUT" = "3" ]; then
    PIBOT_LIDAR='eai-g4'
elif [ "$PIBOT_LIDAR_INPUT" = "4" ]; then
    PIBOT_LIDAR='xtion'
elif [ "$PIBOT_LIDAR_INPUT" = "5" ]; then
    PIBOT_LIDAR='astra'
elif [ "$PIBOT_LIDAR_INPUT" = "6" ]; then
    PIBOT_LIDAR='kinectV1'
else
    PIBOT_LIDAR=$PIBOT_LIDAR_INPUT
fi

echo "export ROS_IP=\`echo \$LOCAL_IP\`" >> ~/.pibotrc
echo "export ROS_HOSTNAME=\`echo \$LOCAL_IP\`" >> ~/.pibotrc
echo "export PIBOT_MODEL=${PIBOT_MODEL}" >> ~/.pibotrc
echo "export PIBOT_LIDAR=${PIBOT_LIDAR}" >> ~/.pibotrc

read -p "please select specify the current machine(ip:$LOCAL_IP) type(0:onboard,other:remote):" PIBOT_MACHINE_VALUE
if [ "$PIBOT_MACHINE_VALUE" = "0" ]; then
    ROS_MASTER_IP_STR="\`echo \$LOCAL_IP\`"
    ROS_MASTER_IP=`echo $LOCAL_IP`
else
    read -p "plase specify the onboard machine ip for commnicationi:" PIBOT_ONBOARD_MACHINE_IP
    ROS_MASTER_IP_STR=`echo $PIBOT_ONBOARD_MACHINE_IP`
    ROS_MASTER_IP=`echo $PIBOT_ONBOARD_MACHINE_IP`
fi

echo "export ROS_MASTER_URI=`echo http://${ROS_MASTER_IP_STR}:11311`" >> ~/.pibotrc

echo "*****************************************************************"
echo "model: " $PIBOT_MODEL 
echo "lidar:" $PIBOT_LIDAR  
echo "local_ip: " ${LOCAL_IP} 
echo "onboard_ip:" ${ROS_MASTER_IP}
echo ""
echo "please execute source ~/.bashrc to make the configure effective"
echo "*****************************************************************"

echo "source ~/pibot_ros/ros_ws/devel/setup.bash" >> ~/.pibotrc 

#alias
echo "alias pibot_bringup='roslaunch pibot_bringup bringup.launch'" >> ~/.pibotrc 
echo "alias pibot_bringup_with_imu='roslaunch pibot_bringup bringup_with_imu.launch'" >> ~/.pibotrc 
echo "alias pibot_lidar='roslaunch pibot_bringup ${PIBOT_LIDAR}.launch'" >> ~/.pibotrc 
echo "alias pibot_base='roslaunch pibot_bringup robot.launch'" >> ~/.pibotrc 
echo "alias pibot_base_with_imu='roslaunch pibot_bringup robot_with_imu.launch'" >> ~/.pibotrc 
echo "alias pibot_control='roslaunch pibot keyboard_teleop.launch'" >> ~/.pibotrc 

echo "alias pibot_gmapping='roslaunch pibot_navigation gmapping.launch'" >> ~/.pibotrc 
echo "alias pibot_gmapping_with_imu='roslaunch pibot_navigation gammaping_with_imu.launch'" >> ~/.pibotrc 
echo "alias pibot_save_map='roslaunch pibot_navigation save_map.launch'" >> ~/.pibotrc 

echo "alias pibot_naviagtion='roslaunch pibot_navigation nav.launch'" >> ~/.pibotrc 
echo "alias pibot_naviagtion_with_imu='roslaunch pibot_navigation nav_with_imu.launch'" >> ~/.pibotrc 
echo "alias pibot_view='roslaunch pibot_navigation view_nav.launch'" >> ~/.pibotrc 

echo "alias pibot_cartographer='roslaunch pibot_navigation cartographer.launch'" >> ~/.pibotrc 
echo "alias pibot_view_cartographer='roslaunch pibot_navigation view_cartographer.launch'" >> ~/.pibotrc 

echo "alias pibot_hector_mapping='roslaunch pibot_navigation hector_mapping.launch'" >> ~/.pibotrc 
echo "alias pibot_hector_mapping_without_imu='roslaunch pibot_navigation hector_mapping_without_odom.launch'" >> ~/.pibotrc 

echo "alias pibot_karto_slam='roslaunch pibot_navigation karto_slam.launch'" >> ~/.pibotrc 

