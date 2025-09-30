#!/bin/bash

mkdir -p /usr/share/pipewire/tmp

for file in /root/config/pipewire/*.conf
do
envsubst < "$file" > /usr/share/pipewire/$(basename "$file")
done

. /usr/local/bin/pipewire-launcher.sh

sleep 5
mkdir -p /tmp/

pactl load-module module-pipe-sink file=/tmp/snapfifo \
    sink_name=snapcast-sink sink_properties=device.description=Snapcast \
    format="$ALSA_PLAYBACK_FORMAT" rate=$ALSA_PLAYBACK_RATE \
    channels=$ALSA_PLAYBACK_CHANNELS \
    position="$ALSA_PLAYBACK_POSITION"

sleep 1

pactl set-default-sink snapcast-sink
