#!/bin/sh

su-exec  root /usr/local/bin/bootstrap.sh

/usr/local/bin/go-librespot.sh

/usr/local/bin/mpd.sh

if [ "$ICECAST_ENABLE" == "true" ]; then
  /usr/local/bin/icecast.sh
  sleep 2
  /usr/local/bin/capture-audio.sh &
fi

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi

