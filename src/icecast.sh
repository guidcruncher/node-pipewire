#!/bin/sh

if [ -f "/local/state/icecast.pid" ]; then
  kill -9 $(cat /local/state/icecast.pid)
  rm /local/state/icecast.pid
fi

icecast -b -c /local/config/icecast/icecast.xml
