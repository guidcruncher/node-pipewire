#!/bin/bash

mkdir -p /usr/share/pipewire/tmp

for file in /root/config/pipewire/*.conf
do
envsubst < "$file" > /usr/share/pipewire/$(basename "$file")
done

. /usr/local/bin/pipewire-launcher.sh

sleep 3

