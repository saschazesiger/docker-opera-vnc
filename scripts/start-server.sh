#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/browser/.Xauthority

echo "---Checking for old logfiles---"
find /browser -name "XvfbLog.*" -exec rm -f {} \;
find /browser -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf /browser/.vnc/*.log /browser/.vnc/*.pid /browser/Singleton*
chmod -R /browser /browser
screen -wipe 2&>/dev/null

echo "---Starting Pulseaudio server---"
pulseaudio -D -vvvvvvv --exit-idle-time=-1
pkill -f "/opt/scripts/server -audio-port 10000 -port 8081"
ffmpeg -f pulse -i default -acodec libmp3lame -ar 44100 -strict experimental -f rtsp rtsp://193.23.160.97:8554/live &



echo "---Starting TurboVNC server---"
vncserver -geometry 1024x768 -depth 16 :99 -rfbport 5900 -noxstartup -securitytypes none 2>/dev/null

echo "---Starting Fluxbox---"
screen -d -m env HOME=/etc /usr/bin/fluxbox

echo "---Starting Opera---"
cd /browser

while true
do
  trickle -d 15000 -u 15000 /usr/bin/opera ${URL} -no-sandbox --disable-accelerated-video --bwsi --new-window --test-type --disable-accelerated-video --disable-gpu --dbus-stub --no-default-browser-check --no-first-run --bwsi --user-data-dir=/browser --disable-features=Titlebar --disable-dev-shm-usage>/dev/null &
  sleep 5
  while pgrep -x "opera" > /dev/null
  do
    sleep 1
  done
done
