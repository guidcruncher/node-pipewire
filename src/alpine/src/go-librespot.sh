#!/bin/sh
export GOLIBRESPOT_REGISTERED=false

if [ -n "$SPOTIFY_AUTHJSON" ] && [ -f "$SPOTIFY_AUTHJSON" ]; then
  SPOTIFY_TOKEN=$(cat "$SPOTIFY_AUTHJSON" | jq .auth.access_token -r)
  SPOTIFY_USERNAME=$(cat "$SPOTIFY_AUTHJSON" | jq .profile.display_name -r)
fi

if [ -f "/local/config/go-librespot/lockfile" ]; then
  rm /local/config/go-librespot/lockfile
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "zeroconf" ]; then
  envsubst < /local/.defaults/go-librespot/config-zeroconf.yml > /local/config/go-librespot/config.yml
  export GOLIBRESPOT_REGISTERED=true
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ 
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "spotify_token" ] && [ -n "$SPOTIFY_USERNAME" ] && [ -n "$SPOTIFY_TOKEN" ]; then
  envsubst < /local/.defaults/go-librespot/config-spotify_token.yml > /local/config/go-librespot/config.yml
  export GOLIBRESPOT_REGISTERED=true
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ 
fi
