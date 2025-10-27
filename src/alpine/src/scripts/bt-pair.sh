#!/bin/bash
set -e

echo "[Bluetooth] Launching bluetoothctl for pairing..."
bluetoothctl <<EOF
power on
agent on
default-agent
scan on
EOF
