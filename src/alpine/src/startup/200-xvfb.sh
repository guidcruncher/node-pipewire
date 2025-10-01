#!/bin/bash

if [ -f "/tmp/.X0-lock" ]; then
    rm /tmp/.X0-lock
fi

# Xvfb -screen $DISPLAY 800x600x24 &

