
#!/bin/sh

mkdir -p /var/run/dbus /run/dbus
export DBUS_SYSTEM_BUS_ADDRESS=$(dbus-daemon --system --print-address)
echo "$DBUS_SYSTEM_BUS_ADDRESS" > /local/.dbus-address
export USER=$(whoami)

if [ -f "/local/.dbus-$USER-address" ]; then
  export DBUS_SESSION_BUS_ADDRESS=$(cat /local/.dbus-"$USER"-address)
else
 export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
 echo "$DBUS_SESSION_BUS_ADDRESS" > /local/.dbus-"$USER"-address
fi


export SNAPSERVER_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:$ALSA_PLAYBACK_CHANNELS"
export SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"

echo "PRETTY_HOSTNAME=$MACHINE_NAME" > /etc/machine-info

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

. /usr/local/bin/pipewire-launcher.sh

pactl load-module module-pipe-sink file=/tmp/snapfifo \
    sink_name=snapcast-sink sink_properties=device.description=Snapcast \
    format="$ALSA_PLAYBACK_FORMAT" rate=$ALSA_PLAYBACK_RATE \
    channels=$ALSA_PLAYBACK_CHANNELS \
    position="$ALSA_PLAYBACK_POSITION"
pactl set-default-sink snapcast-sink

