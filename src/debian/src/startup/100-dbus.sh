#!/bin/bash

echo "PRETTY_HOSTNAME=$MACHINE_NAME" > /etc/machine-info

chmod 700 $XDG_RUNTIME_DIR
mkdir -p /run/dbus

  if [ -d "$DBUS_ADDRESS_DIR" ]; then
    rm -rf "$DBUS_ADDRESS_DIR"
  fi

mkdir -p "$DBUS_ADDRESS_DIR"

   if [ -f "/run/dbus/pid" ]; then
    rm /run/dbus/pid
  fi

export DBUS_SYSTEM_BUS_ADDRESS=$(dbus-daemon --system --fork --print-address)
echo "$DBUS_SYSTEM_BUS_ADDRESS"  > "$DBUS_ADDRESS_DIR"/system-address 

  if [ -f "$DBUS_ADDRESS_DIR"/session-"$USER"-address ]; then
    rm  "$DBUS_ADDRESS_DIR"/session-"$USER"-address
  fi

 export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --session --print-address --fork)
 echo "$DBUS_SESSION_BUS_ADDRESS" > "$DBUS_ADDRESS_DIR"/session-"$USER"-address

if [ "$RTKIT_ENABLE" == "true" ]; then
  rtkitctl --start
else
  export DISABLE_RTKIT=y
fi
