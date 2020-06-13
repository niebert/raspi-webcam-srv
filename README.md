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
* You can install two different servers by calling one of the following installation scripts
  * **motion:**   `sh install_motion_srv.sh`
  * **ffserver:** `sh install_ffserver.sh` - check default settings of the install script

## Start WebCam Server
You can start the WebCam server with start scripts:
  * **motion:**   `sh start_motion_srv.sh`
  * **ffserver:** `sh start_ffserver.sh`
You can also start the `motion` server manually by `sudo motion -c /etc/motion/motion.conf`

## Video Streaming with VLC

### Requirements
* USB WebCam
* USB Soundcard with Audio-In for broadcasting video and sound.

### Installation VLC
The following video/audio broadcast uses the command line VLC `cvlc`. `raspvid` pipes the video stream into the command line VLC `cvlc`.
This was added to the README.md as an alternative for `motion` as an updated stream of still images without audio. The following commands will help you to broadcast a video stream including audio. You will be able to stream 
* video of the webcam and
* audio of a mircophone 
with the command line VLC to HTTP port. In constrast to motion the framerate will be much better. But this will also include a delay of 1-2 seconds. If you use the default Raspberry webcam, activate the camera with `rasp-config`. When the module can be activated, the Pi should be restarted afterwards.

Afterwards the Raspberry Pi should be updated to the latest version with the following commands:
```bash
    sudo apt-get update | apt-get upgrade
```

After the upgrade has been performed, you can install `VLC` with the following command:
```bash
  sudo apt-get install vlc
```
After VLC was installed, it is recommended to reboot the Raspberry Pi, before you can fully set up the video stream. Rebooting the Raspberry can be performed with `sudo reboot` from the console-

Afterwards the stream can be started easily from the console with the following command:
```bash
 /opt/vc/bin/raspivid -o - -t 0 -w 1280 -h 720 -fps 25 -b 1500000 -red 180 | cvlc -vvvv stream:///dev/stdin --sout '#standard{access=http,mux=ts,dst=:8090}' :demux=h264
```

Once the stream has started, all you need to do is open a new network stream in your client VLC player with
```bash
  http://{IP-DES-RASPBERRY-PIS}:8090
```

Please keep in mind that there is no password protection for viewing the video stream. 

## Links
The installation scripts are based on the recommendations of the following resources:
* https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
* https://tutorials-raspberrypi.de/raspberry-pi-ueberwachungskamera-livestream-einrichten/
* https://kopfkino.irosaurus.com/webcam-livestream-mit-dem-raspberry-pi/
