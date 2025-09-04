#!/bin/sh
export GOLIBRESPOT_REGISTERED=false

if [ -n "$SPOTIFY_AUTHJSON" ] && [ -f "$SPOTIFY_AUTHJSON" ]; then
  SPOTIFY_TOKEN=$(cat "$SPOTIFY_AUTHJSON" | jq .auth.access_token -r)
  SPOTIFY_USERNAME=$(cat "$SPOTIFY_AUTHJSON" | jq .profile.display_name -r)
fi

if [ -f "/local/state/go-librespot.pid" ]; then
  kill -9 $(cat /local/state/go-librespot.pid)
  rm /local/state/go-librespot.pid
  rm /local/config/go-librespot/lockfile
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "zeroconf" ]; then
  cp /local/config/go-librespot/config-zeroconf.yml /local/config/go-librespot/config.yml
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &
  export GOLIBRESPOT_REGISTERED=true
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "spotify_token" ] && [ -n "$SPOTIFY_USERNAME" ] && [ -n "$SPOTIFY_TOKEN" ]; then
  cat /local/config/go-librespot/config-spotify_token.yml | \
    sed "s/{SPOTIFY_USERNAME}/$SPOTIFY_USERNAME/g" | \
    sed "s/{SPOTIFY_TOKEN}/$SPOTIFY_TOKEN/g" \
    > /local/config/go-librespot/config.yml
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &
  export GOLIBRESPOT_REGISTERED=true
fi

/usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &
echo $! > /local/state/go-librespot.pid
