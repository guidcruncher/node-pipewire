#!/bin/sh
export DBUS_SYSTEM_BUS_ADDRESS=$(cat "$DBUS_ADDRESS_DIR"/system-address)
export USER=$(whoami)

if [ -f "$DBUS_ADDRESS_DIR"/session-"$USER"-address ]; then
  export DBUS_SESSION_BUS_ADDRESS=$(cat "$DBUS_ADDRESS_DIR"/session-"$USER"-address)
else
 export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
 echo "$DBUS_SESSION_BUS_ADDRESS" > "$DBUS_ADDRESS_DIR"/session-"$USER"-address
fi

