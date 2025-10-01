#!/bin/sh

if [ "$1" == "shutdown" ]; then
  trap 'echo ' ERR SIGINT SIGTERM
  pid=$(pgrep -f ffmpeg)
  if [ -n "$pid" ]; then
    kill $pid
  fi
  pid=$(pgrep -f icecast)
  if [ -n "$pid" ]; then
    kill $pid
  fi
else
  icecast -c /local/config/icecast/icecast.xml
fi
