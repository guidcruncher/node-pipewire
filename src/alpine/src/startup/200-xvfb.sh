#!/bin/bash

echo "Skipping xvfb services"

if [ -f "/tmp/.X0-lock" ]; then
    rm /tmp/.X0-lock
fi

# Xvfb -screen $DISPLAY 800x600x24 &

