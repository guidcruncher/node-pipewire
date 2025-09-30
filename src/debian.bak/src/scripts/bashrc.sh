#!/bin/bash
export DBUS_SYSTEM_BUS_ADDRESS=$(cat /local/.dbus-address)
export USER=$(whoami)

if [ -f "/local/.dbus-$USER-address" ]; then
  export DBUS_SESSION_BUS_ADDRESS=$(cat /local/.dbus-"$USER"-address)
else
 export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
 echo "$DBUS_SESSION_BUS_ADDRESS" > /local/.dbus-"$USER"-address
fi
