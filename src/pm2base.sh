#!/bin/sh
export PM2_HOME="$PM2_BASE_HOME"

pm2 $@

export PM2_HOME="$PM2_CONTAINER_HOME"
