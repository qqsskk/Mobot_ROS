#!/bin/bash

echo "setup pibot modules"
echo " "
sudo cp `rospack find pibot`/rules/pibot.rules  /etc/udev/rules.d
sudo cp `rospack find pibot`/rules/rplidar.rules  /etc/udev/rules.d
sudo cp `rospack find pibot`/rules/ydlidar.rules  /etc/udev/rules.d
echo " "
echo "Restarting udev"
echo ""
sudo service udev reload
sudo service udev restart
echo "finish "
