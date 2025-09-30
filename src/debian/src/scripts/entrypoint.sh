#!/bin/bash

for f in $HOME/startup/*; do
    source "$f" || exit 1
    sleep 2s
done

if [ -n "$1" ]; then
  $@
elsed
  tail -f /dev/null
fi
 
