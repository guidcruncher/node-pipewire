#!/bin/bash
export IR_RESPONSE_FILE="$IR_RESPONSE_BASE"/"$IR_RESPONSE_FILENAME"

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

sleep 2

pactl set-default-sink "input.eq-sink"
