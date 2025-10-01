#!/bin/bash

filename="config-zeroconf.yml"

if [ "$GO_LIBRESPOT_AUTHMODE" == "token" ]; then
  filename="config-spotify_token.yml"
fi

envsubst < "$CONFIG_BASE"/go-librespot/"$filename" > "$GO_LIBRESPOT_STATE"/config.yml

trap 'echo ' ERR SIGINT SIGTERM
pid=$(pgrep -f go-librespot)

  if [ -n "$pid" ]; then
    kill $pid
  fi

if [ -f "$GO_LIBRESPOT_STATE/lockfile" ]; then
  rm "$GO_LIBRESPOT_STATE/lockfile"
fi

/usr/local/bin/go-librespot --config_dir "$GO_LIBRESPOT_STATE" &


