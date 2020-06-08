# raspi-webcam-srv
Raspberry Pi - Webserver installation Script

## Requirements 
* Download the ZIP-file of this repository
* This installation script was used with an attached WebCam LogiTech C270 HD
* The settings for the WebCam server `motion` are defined in `etc_motion_motion.conf`. You can edit the file prior to running the script `install_rasp_webcam_srv.sh` and this file will be copied to `/etc/motion/motion.conf`
* The default settings are defined in `etc_default_motion.conf` and this file will be copied to `/etc/default/motion`

## Installation 
* Install `git` with `sudo apt-get install git` on your Raspberry Pi.
* Clone this repository by `git clone https://github.com/niebert/raspi-webcam-srv.git`
* Change to director `cd raspi-webcam-srv`
* Call installation script `sh install_rasp_webcam_srv.sh`

## Start WebCam Server
* You can start the WebCam server with `sudo motion -c /etc/motion/motion.conf`

## Links
The installation script was based on https://tutorials-raspberrypi.de/raspberry-pi-ueberwachungskamera-livestream-einrichten/
