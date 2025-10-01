#!/bin/bash

filename="config-zeroconf.yml"

if [ "$GOLIBRESPOT_AUTHMODE" == "spotify_token" ]; then
  filename="config-spotify_token.yml"

  if [ -n "$1" ] && [ -n "$2" ]; then
    export SPOTIFY_USERNAME="$1"
    export SPOTIFY_TOKEN="$2"
    echo "Using passed access details"
  else
    if [ -n "$SPOTIFY_USERNAME" ] && [ -n "$SPOTIFY_TOKEN" ]; then
      echo "Got Access details from environment,"
    else
      echo "Access token not specified, aborting. Format : librespot.sh [username] [accesstoken]"
      exit 1
    fi
  fi
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


