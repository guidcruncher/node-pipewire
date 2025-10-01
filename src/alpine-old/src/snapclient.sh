#!/bin/sh

if [ "$1" == "shutdown" ]; then
  trap 'echo ' ERR SIGINT SIGTERM
  pid=$(pgrep -f snapclient)
  if [ -n "$pid" ]; then
    kill $pid
  fi
else
  /usr/bin/snapclient --player alsa -s soundcard  --host 127.0.0.1 \
    --hostID "$SNAPCLIENT_HOSTID" \
    --sampleformat "$SNAPCLIENT_SAMPLEFORMAT" \
    --logsink stdout
fi
