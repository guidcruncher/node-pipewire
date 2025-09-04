#!/bin/sh

su-exec  root /usr/local/bin/bootstrap.sh

/usr/local/bin/go-librespot.sh

/usr/local/bin/mpd.sh

/usr/local/bin/icecast.sh

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi

