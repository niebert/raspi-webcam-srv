#!/bin/sh
START_SCRIPT="start_motion_srv.sh"
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
           sudo cp conf/etc_motion_motion.conf /etc/motion/motion.conf
           echo "Step 6: Copy the default for '/etc/default/motion'"
           sudo cp conf/etc_default_motion.conf /etc/default/motion
           echo "Step 7: Create start script '${START_SCRIPT}' 'motion' with Config File"
           touch $START_SCRIPT
           echo "#!/bin/sh" >> $START_SCRIPT
           echo "sudo motion -c /etc/motion/motion.conf" >> $START_SCRIPT
           echo "Step 8: Start 'motion' with Config File"
           echo "DONE, installed and copied configuration files for motion server."
           touch 
           break;;

   [nN]* ) exit;;

   * )     echo "Do you see you WebCam with 'lsusb' command? Just enter Y or N, please."; break ;;
  esac
done
