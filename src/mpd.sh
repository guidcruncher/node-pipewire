#!/bin/sh

if [ -f "/local/state/mpd.pid" ]; then
  kill -9 $(cat /local/state/mpd.pid)
  rm /local/state/mpd.pid
fi

/usr/bin/mpd -v /local/config/mpd/mpd.conf
