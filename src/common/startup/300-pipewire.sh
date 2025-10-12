
#!/bin/bash
mkdir -p "$XDG_RUNTIME_DIR"
mkdir -p  "$PIPEWIRE_RUNTIME_DIR"

mkdir -p /usr/share/pipewire/tmp
for file in "$CONFIG_BASE"/pipewire/*.conf
do
envsubst < "$file" > /usr/share/pipewire/$(basename "$file")
done

if [ -d "$CONFIG_BASE""/pipewire/pipewire.conf.d" ]; then
mkdir -p /usr/share/pipewire/pipewire.conf.d
for file in "$CONFIG_BASE"/pipewire/pipewire.conf.d/*.conf
do
envsubst < "$file" > /usr/share/pipewire/pipewire.conf.d/$(basename "$file")
done

fi

if [ -d "$CONFIG_BASE""/pipewire/wireplumber.conf.d" ]; then
mkdir -p /usr/share/pipewire/wireplumber.conf.d
for file in "$CONFIG_BASE"/pipewire/wireplumber.conf.d/*.conf
do
envsubst < "$file" > /usr/share/pipewire/wireplumber.conf.d/$(basename "$file")
done
fi

if [ -d "$CONFIG_BASE""/pipewire/pipewire-pulse.conf.d" ]; then
mkdir -p /usr/share/pipewire/pipewire-pulse.conf.d
for file in "$CONFIG_BASE"/pipewire/pipewire-pulse.conf.d/*.conf
do
envsubst < "$file" > /usr/share/pipewire/pipewire-pulse.conf.d/$(basename "$file")
done
fi

if [ -d "$CONFIG_BASE""/pipewire/filter-chain.conf.d" ]; then
mkdir -p /usr/share/pipewire/filter-chain.conf.d
for file in "$CONFIG_BASE"/pipewire/filter-chain.conf.d/*.conf
do
envsubst < "$file" > /usr/share/pipewire/filter-chain.conf.d/$(basename "$file")
done
fi

. /usr/local/bin/pipewire-launcher.sh

sleep 3
mkdir -p /tmp/

pactl load-module module-pipe-sink file=/tmp/snapfifo \
    sink_name=snapcast-sink sink_properties=device.description=Snapcast \
    format="$ALSA_PLAYBACK_FORMAT" rate=$ALSA_PLAYBACK_RATE \
    channels=$ALSA_PLAYBACK_CHANNELS \
    channel_map=front-left,front-right \
    position="$ALSA_PLAYBACK_POSITION" \
    object.linger=1

pactl set-default-sink "input.eq-sink"
