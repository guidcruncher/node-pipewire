#!/bin/sh

echo "PRETTY_HOSTNAME=$MACHINE_NAME" > /etc/machine-info

if [ -f "/app/init.sh" ]; then
  /app/init.sh
fi

ln -f -s "/usr/share/zoneinfo/$TZ" '/etc/localtime'
echo "$TZ" | tee /etc/timezone

mkdir -p /local/config /local/cache /local/share /local/state /tmp/runtime

cp -R -u -p /local/.defaults/* /local/config

for file in /local/.defaults/pipewire/*.conf
do
  envsubst < "$file" > /local/config/pipewire/$(basename "$file")
done

for file in /local/.defaults/go-librespot/*.yml
do
  envsubst < "$file" > /local/config/go-librespot/$(basename "$file")
done

for file in /local/.defaults/snapserver/*.conf
do
  envsubst < "$file" > /local/config/snapserver/$(basename "$file")
done

cp -R /pipewire-config/* /local/config/pipewire

openrc default

rc-update add dbus
rc-service dbus start

rc-service bluetooth start

if [ ! -e "/tmp/dbus-$USER-env" ]; then
       export $(dbus-launch)
       echo "${DBUS_SESSION_BUS_ADDRESS}" > /tmp/dbus-$USER-env
else
       export DBUS_SESSION_BUS_ADDRESS="$(cat /tmp/dbus-$USER-env)"
fi

if [ "$RTKIT_ENABLE" == "true" ]; then
  rtkitctl --start 
else
  export DISABLE_RTKIT=y
fi

/usr/local/bin/pipewire-launcher.sh

sleep 2

pactl load-module module-pipe-sink file=/tmp/snapfifo \
    sink_name=snapcast-sink sink_properties=device.description=Snapcast \
    format=$ALSA_PLAYBACK_FORMAT rate=$ALSA_PLAYBACK_RATE \
    channels=$ALSA_PLAYBACK_CHANNELS
pactl set-default-sink snapcast-sink

if [ -d "/usr/local/bin/node-pipewire.d" ]; then
  for script in /usr/local/bin/node-pipewire.d/*.sh ; do
    if [ -r "$script" ] ; then
      . "$script"
    fi
  done
  unset script
fi
