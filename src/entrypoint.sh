#!/bin/sh

su-exec  root /usr/local/bin/bootstrap.sh

/usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &

/usr/bin/mpd -v /local/config/mpd/mpd.conf

icecast -b -c /local/config/icecast/icecast.xml

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi

