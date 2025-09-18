#!/bin/sh

for file in /local/.defaults/snapserver/*.conf
do
  rm  /local/config/snapserver/$(basename "$file")
  envsubst < "$file" > /local/config/snapserver/$(basename "$file")
done

/usr/bin/snapserver -c /local/config/snapserver/snapserver.conf
