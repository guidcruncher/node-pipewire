#!/bin/bash

echo "Starting Pipewire services"

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

if [ "$USE_PIPEWIRE_EQ" != "true" ]; then
  rm /usr/share/pipewire/pipewire.conf.d/100-eq.conf
fi

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

# pactl set-default-sink "$PW_DEFAULT_SINK"
pactl set-default-sink "input.eq-sink"

echo "Pipewire started"
