#!/bin/bash

filename="config-zeroconf.yml"

if [ "$GOLIBRESPOT_AUTHMODE" == "token" ]; then
  filename="config-spotify_token.yml"
fi

envsubst < "$CONFIG_BASE"/go-librespot/"$filename" > "$GOLIBRESPOT_STATE"/config.yml

trap 'echo ' ERR SIGINT SIGTERM
pid=$(pgrep -f go-librespot)

  if [ -n "$pid" ]; then
    kill $pid
  fi

if [ -f "$GOLIBRESPOT_STATE/lockfile" ]; then
  rm "$GOLIBRESPOT_STATE/lockfile"
fi

/usr/local/bin/go-librespot --config_dir "$GOLIBRESPOT_STATE" &


