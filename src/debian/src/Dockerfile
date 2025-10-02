FROM debian:bookworm-slim AS base
ARG ARCH
ARG SNAPCAST_VERSION=0.33.0
ARG LIBRESPOT_VERSION=0.4.0
ARG NODE_VERSION=22
 
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    alsa-tools \
    alsa-utils \
    avahi-daemon \
    avahi-utils \
    bluez \
    ca-certificates \
    curl \
    dbus-x11 \
    findutils \
    ffmpeg \
    gettext-base \
    gzip \
    jq \
    libasound2 \
    libasound2-plugin-equal \
    libcamera-ipa \
    libpipewire-0.3-dev \
    nano \
    pipewire-audio \
    pipewire-libcamera \
    procps \
    pulseaudio-utils \
    rtkit \
    unzip \
    xvfb \
    xz-utils

RUN <<EOF
groupadd -r -f -g 1001 appgroup
groupadd -r -f pipewire
groupadd -r -f rtkit
groupadd -r -f sudo

useradd --system --shell /bin/bash -u 1001 \
  -G sudo  -G rtkit -G pipewire -G appgroup \
  -p none appuser
passwd -d appuser

curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
apt install -y nodejs
node -v

mkdir /.dbus
mkdir ./sw
cd ./sw

TARGETARCH="$ARCH"

if [ -z "$TARGETARCH" ]; then
  TARGETARCH="$(uname -m)"
fi

if [ "$TARGETARCH" = "aarch64" ]; then
  TARGETARCH="arm64"
fi

curl -L "https://github.com/badaix/snapcast/releases/download/v$SNAPCAST_VERSION/snapclient_$SNAPCAST_VERSION-1_""$TARGETARCH""_bookworm.deb" -o ./snapclient.deb
curl -L "https://github.com/badaix/snapcast/releases/download/v""$SNAPCAST_VERSION""/snapserver_""$SNAPCAST_VERSION""-1_""$TARGETARCH""_bookworm_with-pipewire.deb" -o ./snapserver.deb
curl -L "https://github.com/devgianlu/go-librespot/releases/download/v""$LIBRESPOT_VERSION""/go-librespot_linux_$TARGETARCH.tar.gz" -o ./librespot.tar.gz

tar xvf ./librespot.tar.gz go-librespot
chmod +x ./go-librespot
mv ./go-librespot /usr/local/bin/

mv /etc/snapserver.conf /etc/snapserver.bak

apt install -y ./snapclient.deb
apt install -y ./snapserver.deb
apt -f install -y

cd ..
rm -rf ./sw

apt-get clean && \
rm -rf /var/lib/apt/lists/*
npm install -g typescript ts-node tslib @types/node pm2
mkdir -p /app /config
EOF

FROM base AS runtime

ENV APP_BASE="/app"
ENV APP_STARTUP="/app/startup"
ENV CONFIG_BASE="/config"

ENV XDG_RUNTIME_DIR=/tmp
ENV PIPEWIRE_RUNTIME_DIR=/tmp
ENV PULSE_RUNTIME_DIR=/tmp
ENV DBUS_ADDRESS_DIR=/.dbus
ENV DISPLAY=:0.0

ENV ALSA_PLAYBACK_DEVICE="hw:AUDIO,0"
ENV ALSA_PLAYBACK_RATE=48000
ENV ALSA_PLAYBACK_FORMAT="S16LE"
ENV ALSA_PLAYBACK_CHANNELS=2
ENV ALSA_PLAYBACK_POSITION="FL,FR"
ENV ALSA_EQUAL_MIXER="soundcard"
ENV ALSA_BITS_PER_SAMPLE=16

ENV SNAPSERVER_DATADIR=${CONFIG_BASE}/snapserver/
ENV SNAPSERVER_CODEC=flac
ENV SNAPSERVER_CHUNK_MS=26
ENV SNAPSERVER_BUFFER=1000
ENV SNAPCLIENT_HOSTID=Pipewire-Local
ENV SNAPSERVER_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:$ALSA_PLAYBACK_CHANNELS"
ENV SNAPSERVER_SOURCE="pipe:///tmp/snapfifo?name=pipewire&sampleformat=$SNAPSERVER_SAMPLEFORMAT"
ENV SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"
ENV RTKIT_ENABLE="true"

ENV PM2_CONTAINER_HOME=/root/pm2/container
ENV PM2_HOME=${PM2_CONTAINER_HOME}

ENV GOLIBRESPOT_API="http://127.0.0.1:3678"
ENV GOLIBRESPOT_AUTHMODE="zeroconf"
ENV GOLIBRESPOT_STATE=${CONFIG_BASE}/go-librespot-state
ENV SPOTIFY_USERNAME=""
ENV SPOTIFY_TOKEN=""
ENV SPOTIFY_DEVICE_NAME="go-librespot"
ENV MACHINE_NAME=Pipewire-Docker

RUN mkdir -p /etc/profile.d $CONFIG_BASE $APP_BASE $APP_STARTUP $GOLIBRESPOT_STATE

WORKDIR ${APP_BASE}

COPY ./config/ ${CONFIG_BASE}/
COPY ./global/asound.conf /etc/asound.conf

COPY ./startup/ ${APP_STARTUP}
COPY ./scripts/*.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/*.sh && \
    chmod 755 $APP_STARTUP/*.sh && \
    mv /usr/local/bin/bashrc.sh /etc/profile.d/bashrc.sh

WORKDIR ${APP_BASE}

CMD ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

