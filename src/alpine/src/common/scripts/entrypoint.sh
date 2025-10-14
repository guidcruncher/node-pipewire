#!/bin/sh

for f in $APP_STARTUP/*; do
    source "$f" || exit 1
    sleep 2s
done

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi
 
