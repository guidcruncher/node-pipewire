#!/bin/sh

mkdir -p $HOKE/.fluxbox/
echo  "/usr/bin/easyeffects" > $HOKE/.fluxbox/startup

export DISPLAY=43:-:0

xdpyinfo

if which x11vnc &>/dev/null; then
  ! pgrep -a x11vnc && x11vnc -bg -forever -nopw -quiet -display WAIT$DISPLAY &
fi

! pgrep -a Xvfb && Xvfb $DISPLAY -screen 0 1024x768x16 &

sleep 1

if which fluxbox &>/dev/null; then
  ! pgrep -a fluxbox && fluxbox 2>/dev/null &
fi

echo "IP: $(hostname -i) ($(hostname))"
