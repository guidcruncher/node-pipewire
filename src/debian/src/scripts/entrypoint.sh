#!/bin/bash

for f in $HOME/startup/*; do
    source "$f" || exit 1
    sleep 2s
done

if [ -n "$1" ]; then
  $@
else
  tail -f /dev/null
fi
 
