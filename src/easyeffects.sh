#!/bin/sh

if [[ "$1" = "start" ]]; then
	kill $(pgrep -f Xvfb)
	sleep 1
	Xvfb :43 -screen 0 1024x768x16 &
	sleep 3
	export DISPLAY=:43
	easyeffects --gapplication-service
fi

if [[ "$1" = "stop" ]]; then
	easyeffects --quit
	kill $(pgrep -f Xvfb)
fi
