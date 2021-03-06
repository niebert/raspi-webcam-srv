#!/bin/sh
## Install ffserver and create config file
## GitHub-Source: https://github.com/niebert/raspi-webcam-srv
## Further Information see URL: https://kopfkino.irosaurus.com/webcam-livestream-mit-dem-raspberry-pi/
## The following variable define the Videostream
CONF_DIR="./conf"
CONF_FILE="${CONF_DIR}/etc_motion_motion.conf"
START_SCRIPT="start_motion_srv.sh"
STOP_SCRIPT="stop_motion_srv.sh"
# E.g.set stream_port 8081
SERVER_STREAM_PORT="8081"
## Default for VIDEO_STREAM_MAXRATE is 1 - means slow update of stream images
VIDEO_STREAM_MAXRATE="25"
VIDEO_FRAME_RATE="100"
## Video Stream Quality percentage of the source video stream (default 50 means 50%)
VIDEO_STREAM_QUALITY="100"
# Video Stream Size
VIDEO_SIZE_WIDTH="352"
VIDEO_SIZE_HEIGHT="288"
## For LogiTech C270 set e.g. size to
VIDEO_SIZE_WIDTH="704"
VIDEO_SIZE_HEIGHT="576"
VIDEO_SCALE_BROWSER="100" 

echo "Install WebCam Server with Motion"
#### stop the 'motion' service if service is running ###
sudo service motion stop
echo "Step 1: Update Software Repository List" 
sudo apt-get update
echo "Step 2: Upgrade the Software"
sudo apt-get upgrade
echo "Step 3: Install Software 'git' and 'motion'"
sudo apt-get install motion -y
echo "Step 4: Check attached USB Devices" 
echo " "
read -p "WebCam Width (e.g. ${VIDEO_SIZE_WIDTH})? " sizeinput
if [ -z "$sizeinput" ]
then
      echo "WARNING: \$sizeinput is empty. Use default VIDEO_SIZE_WIDTH='${VIDEO_SIZE_WIDTH}'"
else
      echo "Set VIDEO_SIZE_WIDTH='$sizeinput'"
      VIDEO_SIZE_WIDTH="$sizeinput"
fi
read -p "WebCam Height (e.g. ${VIDEO_SIZE_HEIGHT})? " sizeinput
if [ -z "$sizeinput" ]
then
      echo "WARNING: \$sizeinput is empty. Use default VIDEO_SIZE_HEIGHT='${VIDEO_SIZE_HEIGHT}'"
else
      echo "Set VIDEO_SIZE_HEIGHT='$sizeinput' "
      VIDEO_SIZE_HEIGHT="$sizeinput"
fi
read -p "WebCam Video Scale Browser (e.g. ${VIDEO_SCALE_BROWSER})? " sizeinput
if [ -z "$sizeinput" ]
then
      echo "WARNING: \$sizeinput is empty. Use default VIDEO_SCALE_BROWSER='${VIDEO_SCALE_BROWSER}'"
else
      echo "Set VIDEO_SCALE_BROWSER='$sizeinput'"
      VIDEO_SCALE_BROWSER="$sizeinput"
fi
echo "List of USB Device"
echo "------------------"
lsusb
echo " "
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
           cp ./conf/etc_motion.tpl $CONF_FILE
           echo "  6.1 Replace 'MOTION_VIDEO_SIZE_WIDTH' by '${VIDEO_SIZE_WIDTH}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_SIZE_WIDTH/${VIDEO_SIZE_WIDTH}/g" $CONF_FILE
           echo "  6.2 Replace 'MOTION_VIDEO_SIZE_HEIGHT' by '${VIDEO_SIZE_HEIGHT}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_SIZE_HEIGHT/${VIDEO_SIZE_HEIGHT}/g" $CONF_FILE
           echo "  6.3 Replace 'MOTION_VIDEO_STREAM_MAXRATE' by '${VIDEO_STREAM_MAXRATE}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_STREAM_MAXRATE/${VIDEO_STREAM_MAXRATE}/g" $CONF_FILE 
           echo "  6.4 Replace 'MOTION_VIDEO_STREAM_QUALITY' by '${VIDEO_STREAM_QUALITY}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_STREAM_QUALITY/${VIDEO_STREAM_QUALITY}/g" $CONF_FILE 
           echo "  6.5 Replace 'MOTION_SERVER_STREAM_PORT' by '${SERVER_STREAM_PORT}' in file $CONF_FILE"
           sed -i "s/MOTION_SERVER_STREAM_PORT/${SERVER_STREAM_PORT}/g" $CONF_FILE 
           echo "  6.6 Replace 'MOTION_VIDEO_FRAME_RATE' by '${VIDEO_FRAME_RATE}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_FRAME_RATE/${VIDEO_FRAME_RATE}/g" $CONF_FILE 
           echo "  6.7 Replace 'MOTION_VIDEO_SCALE_BROWSER' by '${VIDEO_SCALE_BROWSER}' in file $CONF_FILE"
           sed -i "s/MOTION_VIDEO_SCALE_BROWSER/${VIDEO_SCALE_BROWSER}/g" $CONF_FILE 
             
           sudo cp $CONF_FILE /etc/motion/motion.conf
           echo "Step 7: Copy the default for '/etc/default/motion'"
           sudo cp ./conf/etc_default_motion.conf /etc/default/motion
           echo "Step 8: Create start script '${START_SCRIPT}' 'motion' with Config File"
           touch $START_SCRIPT
           echo "#!/bin/sh" >> $START_SCRIPT
           echo "sudo rm -R ~/Monitor/*" >> $START_SCRIPT
           echo "sudo motion -c /etc/motion/motion.conf" >> $START_SCRIPT
           echo "Step 9: Create stop script '${STOP_SCRIPT}' for server 'motion'"
           touch $STOP_SCRIPT
           echo "#!/bin/sh" >> $STOP_SCRIPT
           echo "sudo service motion stop" >> $STOP_SCRIPT
           echo "Step 10: Now you can start 'motion' with config file with:"
           echo "  sudo motion -c /etc/motion/motion.conf"
           echo "or with the start script '${START_SCRIPT}' by"
           echo "  sh ${START_SCRIPT}"
           echo "or with the start script '${STOP_SCRIPT}' by"
           echo "  sh ${STOP_SCRIPT}"
           echo "DONE, installed and copied configuration files for motion server." 
           break;;

   [nN]* ) exit;;

   * )     echo "Do you see you WebCam with 'lsusb' command? Just enter Y or N, please."; break ;;
  esac
done
