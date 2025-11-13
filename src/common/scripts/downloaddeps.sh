#!/bin/sh
mkdir ./sw
cd ./sw

export DEBIAN_FRONTEND=noninteractive
TARGETARCH="$ARCH"

if [ -z "$TARGETARCH" ]; then
  TARGETARCH="$(uname -m)"
fi

if [ "$TARGETARCH" = "aarch64" ]; then
  TARGETARCH="arm64"
fi

curl -L "https://github.com/badaix/snapcast/releases/download/v0.33.0/snapclient_0.33.0-1_""$TARGETARCH""_bookworm.deb" -o ./snapclient.deb
curl -L "https://github.com/badaix/snapcast/releases/download/v0.33.0/snapserver_0.33.0-1_""$TARGETARCH""_bookworm_with-pipewire.deb" -o ./snapserver.deb
curl -L "https://github.com/devgianlu/go-librespot/releases/download/v0.5.3/go-librespot_linux_$TARGETARCH.tar.gz" -o ./librespot.tar.gz

tar xvf ./librespot.tar.gz go-librespot
chmod +x ./go-librespot
mv ./go-librespot /usr/local/bin/

mv /etc/snapserver.conf /etc/snapserver.bak

apt install -y ./snapclient.deb
apt install -y ./snapserver.deb
apt -f install -y

mv /etc/snapserver.bak /etc/snapserver.conf

rm ./snapserver.deb
rm ./snapclient.deb
rm ./librespot.tar.gz

export DEBIAN_FRONTEND=

cd ..
rm -rf ./sw
