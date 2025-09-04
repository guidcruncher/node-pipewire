#!/bin/sh
mkdir -p /local/config /local/cache /local/share /local/state /tmp/runtime

cp -R -u -p /local/.defaults/* /local/config
openrc default

rc-update add dbus
rc-service dbus start

if [ ! -e "/tmp/dbus-$USER-env" ]; then
       export $(dbus-launch)
       echo "${DBUS_SESSION_BUS_ADDRESS}" > /tmp/dbus-$USER-env
else
       export DBUS_SESSION_BUS_ADDRESS="$(cat /tmp/dbus-$USER-env)"
fi

rtkitctl --start

/usr/local/bin/pipewire-launcher.sh

sleep 2

/usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &

/usr/bin/mpd -v /local/config/mpd/mpd.conf

icecast -b -c /local/config/icecast/icecast.xml

if [ -n "$1" ]; then
  $@
fi

tail -f /dev/null
