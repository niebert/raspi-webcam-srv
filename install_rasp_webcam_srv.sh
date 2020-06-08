#!/bin/sh
echo "Install WebCam Server with Motion"
echo "Step 1: Update Software Repository List" 
sudo apt-get update
echo "Step 2: Upgrade the Software"
sudo apt-get upgrade
echo "Step 3: Install Software 'git' and 'motion'"
sudo apt-get install motion -y
echo "Step 4: Check attached USB Devices" 
# (P1) prompt user, and read command line argument
read -p "Do you see your WebCam in list of USB devices? " answer

# (2) handle the command line argument we were given
while true
do
  case $answer in
   [yY]* ) 
           echo "Step 5: Create '/home/pi/Monitor Directory"
           mkdir /home/pi/Monitor
           mkdir /home/pi/Monitor
           sudo chgrp motion /home/pi/Monitor
           chmod g+rwx /home/pi/Monitor
           echo "Step 6: Copy the default 'motion.conf' to '/etc/motion/motion.conf'"
           sudo cp etc_motion_motion.conf /etc/motion/motion.conf
           echo "Step 6: Copy the default for '/etc/default/motion'"
           sudo cp etc_default_motion.conf /etc/default/motion
           echo "Step 7: Start 'motion' with Config File"
           sudo motion -c /etc/motion/motion.conf
           echo "Okay, just installed server script."
           break;;

   [nN]* ) exit;;

   * )     echo "Do you see you WebCam with 'lsusb' command? Just enter Y or N, please."; break ;;
  esac
done
