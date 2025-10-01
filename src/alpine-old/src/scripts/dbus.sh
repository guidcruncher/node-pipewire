#!/bin/sh

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/tmp/$UID

sudo -E mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME \
  $XDG_STATE_HOME $XDG_RUNTIME_DIR

sudo -E chown $USER:appgroup $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME \
  $XDG_STATE_HOME $XDG_RUNTIME_DIR -R

sudo -E chmod 700 $XDG_RUNTIME_DIR

if [ ! -e "/tmp/dbus-$USER-env" ]; then
       export $(dbus-launch)
       echo "${DBUS_SESSION_BUS_ADDRESS}" > /tmp/dbus-$USER-env
else
       export DBUS_SESSION_BUS_ADDRESS="$(cat /tmp/dbus-$USER-env)"
fi

