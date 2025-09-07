#!/bin/sh
export GOLIBRESPOT_REGISTERED=false
currpid=$(prep -f go-librespot)

if [ -n "$currpid" ]; then
echo "go-librespot running"
exit
fi

if [ -n "$SPOTIFY_AUTHJSON" ] && [ -f "$SPOTIFY_AUTHJSON" ]; then
  SPOTIFY_TOKEN=$(cat "$SPOTIFY_AUTHJSON" | jq .auth.access_token -r)
  SPOTIFY_USERNAME=$(cat "$SPOTIFY_AUTHJSON" | jq .profile.display_name -r)
fi

if [ -f "/local/state/go-librespot.pid" ]; then
  kill -9 $(cat /local/state/go-librespot.pid)
  kill -9 $(prep -f go-librespot)
  rm /local/state/go-librespot.pid
  rm /local/config/go-librespot/lockfile
fi

if [ -f "/local/config/go-librespot/lockfile" ]; then
  rm /local/config/go-librespot/lockfile
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "zeroconf" ]; then
  envsubst < /local/.defaults/go-librespot/config-zeroconf.yml > /local/config/go-librespot/config.yml
  export GOLIBRESPOT_REGISTERED=true
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &
  echo $! > /local/state/go-librespot.pid
fi

if [ "$GOLIBRESPOT_CREDENTIAL_TYPE" == "spotify_token" ] && [ -n "$SPOTIFY_USERNAME" ] && [ -n "$SPOTIFY_TOKEN" ]; then
  envsubst < /local/.defaults/go-librespot/config-spotify_token.yml > /local/config/go-librespot/config.yml
  export GOLIBRESPOT_REGISTERED=true
  /usr/local/bin/go-librespot --config_dir /local/config/go-librespot/ &
  echo $! > /local/state/go-librespot.pid
fi
