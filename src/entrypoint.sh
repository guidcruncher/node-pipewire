#!/bin/sh

su-exec  root /usr/local/bin/bootstrap.sh
services="go-librespot,mpd"

if [ "$ICECAST_ENABLE" == "true" ]; then
  services="$services,icecast,capture-audio"
fi

export PM2_HOME="$PM2_BASE_HOME"

pm2 start /local/config/pm2/ecosystem.config.cjs --only "$services"

export PM2_HOME="$PM2_CONTAINER_HOME"

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi

