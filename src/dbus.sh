#!/bin/sh

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=/tmp/$UID

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

if [ ! -e "/tmp/dbus-$USER-env" ]; then
       export $(dbus-launch)
       echo "${DBUS_SESSION_BUS_ADDRESS}" > /tmp/dbus-$USER-env
else
       export DBUS_SESSION_BUS_ADDRESS="$(cat /tmp/dbus-$USER-env)"
fi

