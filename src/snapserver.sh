#!/bin/sh

if [ "$1" == "shutdown" ]; then
  trap 'echo ' ERR SIGINT SIGTERM
  pid=$(pgrep -f snapserver)
  if [ -n "$pid" ]; then
    kill $pid
  fi
  pid=$(pgrep -f snapclient)
  if [ -n "$pid" ]; then
    kill $pid
  fi
else
  for file in /local/.defaults/snapserver/*.conf
  do
    rm  /local/config/snapserver/$(basename "$file")
    envsubst < "$file" > /local/config/snapserver/$(basename "$file")
  done

  /usr/bin/snapserver -d -c /local/config/snapserver/snapserver.conf
fi
