#!/bin/sh

if [ "$1" == "shutdown" ]; then
  trap 'echo ' ERR SIGINT SIGTERM
  kill $(pgrep -f ffmpeg)
  kill $(pgrep -f icecast)
else
  icecast -c /local/config/icecast/icecast.xml
fi
