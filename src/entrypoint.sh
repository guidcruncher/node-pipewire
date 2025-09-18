#!/bin/sh

su-exec  root /usr/local/bin/bootstrap.sh

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

