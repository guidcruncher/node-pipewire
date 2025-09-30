#!/bin/bash

envsubst < /root/config/snapserver/snapserver.conf > /etc/snapserver.conf

trap 'echo ' ERR SIGINT SIGTERM
pid=$(pgrep -f snapserver)

  if [ -n "$pid" ]; then
    kill $pid
  fi

pid=$(pgrep -f snapclient)

  if [ -n "$pid" ]; then
    kill $pid
  fi

/usr/bin/snapserver -d -c /etc/snapserver.conf

sleep 3

/usr/bin/snapclient -d --player alsa -s soundcard \
    --hostID "$SNAPCLIENT_HOSTID" \
    --sampleformat "$SNAPCLIENT_SAMPLEFORMAT" \
    --logsink stdout \
    127.0.0.1
