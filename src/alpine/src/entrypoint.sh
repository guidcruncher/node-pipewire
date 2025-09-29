#!/bin/sh

set -a

export SNAPSERVER_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:$ALSA_PLAYBACK_CHANNELS"
export SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"

if [ -f "/app/init.sh" ]; then
  source /app/init.sh
fi

if [ -f "/local/.env" ]; then
  source /local/.env
fi

su-exec  root /usr/local/bin/bootstrap.sh

set +a

export PM2_HOME="$PM2_BASE_HOME"

if [ -n "$ENABLE_SERVICES" ]; then
  pm2 start /local/config/pm2/ecosystem.config.cjs --only "$ENABLE_SERVICES"
else
  pm2 start /local/config/pm2/ecosystem.config.cjs
fi

export PM2_HOME="$PM2_CONTAINER_HOME"

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi

