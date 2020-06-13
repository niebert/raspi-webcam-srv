#!/bin/sh
## Install ffserver and create config file
## GitHub-Source: https://github.com/niebert/raspi-webcam-srv
## Further Information see URL: https://kopfkino.irosaurus.com/webcam-livestream-mit-dem-raspberry-pi/
## The following variable define the Videostream

SERVER_PORT="8091"
CONF_DIR="./conf"
CONF_FILE="${CONF_DIR}/ffserver_webm.conf"
START_SCRIPT="start_ffserver.sh"
STREAM_NAME="webcam"
STREAM_FORMAT="webm"
VIDEO_SIZE="704×576"
## Set Frames per second 
## 25 framerate standard video Europe)
## VIDEO_FRAME_RATE="25"
VIDEO_FRAME_RATE="4"
echo "Install ffserver with aptitude"
echo "------------------------------"
echo "Server Port:        ${SERVER_PORT}"
echo "Configuration file: ${CONF_FILE}"
echo "Stream File Name:   ${STREAM_NAME}.${STREAM_FORMAT}"
echo "Video SIZE:         ${VIDEO_SIZE}"
echo "Video Frame Rate:   ${VIDEO_FRAME_RATE}"
echo "(1) Create Configuration File: ${CONF_FILE}"
## create the configuration directory
mkdir -p $CONF_DIR
## create an empty configuration file
touch $CONF_FILE 
echo "Port ${SERVER_PORT}" >> $CONF_FILE
echo "BindAddress 0.0.0.0" >> $CONF_FILE
echo "MaxClients 10" >> $CONF_FILE
echo "MaxBandwidth 50000" >> $CONF_FILE
echo "NoDaemon" >> $CONF_FILE
echo "<Feed ${STREAM_NAME}.ffm>" >> $CONF_FILE
echo "file ${STREAM_NAME}.ffm" >> $CONF_FILE
echo "FileMaxSize 10M" >> $CONF_FILE
echo "</Feed>" >> $CONF_FILE
echo "<Stream ${STREAM_NAME}.$[STREAM_FORMAT}>" >> $CONF_FILE
echo "Feed ${STREAM_NAME}.ffm" >> $CONF_FILE
echo "Format $[STREAM_FORMAT}" >> $CONF_FILE
echo "AudioCodec vorbis" >> $CONF_FILE
echo "AudioBitRate 64" >> $CONF_FILE
echo "VideoCodec libvpx" >> $CONF_FILE
echo "VideoSize ${VIDEO_SIZE}" >> $CONF_FILE
echo "VideoFrameRate $VIDEO_FRAMERATE" >> $CONF_FILE
echo "AVOptionVideo flags +global_header" >> $CONF_FILE
echo "AVOptionVideo cpu-used 0" >> $CONF_FILE
echo "AVOptionVideo qmin 10" >> $CONF_FILE
echo "AVOptionVideo qmax 42" >> $CONF_FILE
echo "AVOptionVideo quality good" >> $CONF_FILE
echo "AVOptionAudio flags +global_header" >> $CONF_FILE
echo "PreRoll 15" >> $CONF_FILE
echo "StartSendOnKey" >> $CONF_FILE
echo "VideoBitRate 400" >> $CONF_FILE
echo "</Stream>" >> $CONF_FILE
### Now create the start script
echo "(2) Create Start Script for Server: ${START_SCRIPT}"
touch ${START_SCRIPT}
echo "ffserver -f ${CONF_FILE} & ffmpeg -v verbose -r 5 -s ${VIDEO_SIZE} -f video4linux2 -i /dev/video0 -f lavfi -i aevalsrc=0 -c:a libmp3lame http://localhost:${SERVER_PORT}/${STREAM_NAME}.ffm" >> $START_SCRIPT
echo "(3) Compile ffserver"
echo "(3.1) Update Upgrade for 'apt-get'"
sudo apt-get update
sudo apt-get upgrade
echo "(3.2) Install checkinstall"
sudo apt-get install checkinstall
sudo apt-get install yasm
sudo  apt-get install libmp3lame-dev libopus-dev

sudo apt-get -y install autoconf automake build-essential git libass-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev
checkinstall yasm libmp3lame-dev libopus-dev
echo "(3.3) Create '/ffmpeg_sources' "
### recursive remove of previous 'ffmepg_source' 
rm -R  ~/ffmpeg_sources
### create a new empty directory 'ffmepg_source'
mkdir ~/ffmpeg_sources
cd ~/ffmpeg_sources
git clone git://git.videolan.org/x264.git
cd x264
./configure –prefix=“$HOME/ffmpeg_build“ –bindir=“$HOME/bin“ –enable-static
make
sudo checkinstall
cd ~/ffmpeg_sources
git clone git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure –prefix=“$HOME/ffmpeg_build“ –disable-shared
sudo checkinstall
cd ~/ffmpeg_sources
git clone http://git.chromium.org/webm/libvpx.git
cd libvpx
./configure –prefix=“$HOME/ffmpeg_build“ –disable-examples
make
sudo checkinstall
cd ~/ffmpeg_sources
git clone git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH=“$HOME/ffmpeg_build/lib/pkgconfig“
export PKG_CONFIG_PATH
./configure
–extra-cflags=“-I$HOME/ffmpeg_build/include“ –extra-ldflags=“-L$HOME/ffmpeg_build/lib“
–bindir=“$HOME/bin“ –extra-libs=“-ldl“ –enable-gpl –enable-libass –enable-libfdk-aac
–enable-libmp3lame –enable-libopus –enable-libtheora –enable-libvorbis
–enable-libvpx   –enable-libx264 –enable-nonfree –enable-x11grab
make
sudo checkinstall
echo "Installation of ffserver DONE"
echo "------------------------------"
echo "Server Port:        ${SERVER_PORT}"
echo "Configuration file: ${CONF_FILE}"
echo "Stream File Name:   ${STREAM_NAME}.${STREAM_FORMAT}"
echo "Video SIZE:         ${VIDEO_SIZE}"
echo "Video Frame Rate:   ${VIDEO_FRAME_RATE}"
echo "Performed Steps:"
echo "(1) Created Configuration File:      ${CONF_FILE}"
echo "(2) Created Start Script for Server: ${START_SCRIPT}"
echo "(3) Compiled ffserver"
