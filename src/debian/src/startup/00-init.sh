#!/bin/bash

chmod 700 $XDG_RUNTIME_DIR
mkdir -p /run/dbus

  if [ -f "/run/dbus/pid" ]; then
    rm /run/dbus/pid
  fi

export DBUS_SYSTEM_BUS_ADDRESS=$(dbus-daemon --system --fork --print-address)
echo "$DBUS_SYSTEM_BUS_ADDRESS"  > /local/.dbus-address 

if [ -f "/local/.dbus-$USER-address" ]; then
  export DBUS_SESSION_BUS_ADDRESS=$(cat /local/.dbus-"$USER"-address)
else
 export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
 echo "$DBUS_SESSION_BUS_ADDRESS" > /local/.dbus-"$USER"-address
fi

if [ -f "/tmp/.X0-lock" ]; then
    rm /tmp/.X0-lock
fi

Xvfb -screen $DISPLAY 800x600x24 &

