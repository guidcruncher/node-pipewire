FROM debian:bookworm AS base
ARG ARCH
ARG SNAPCAST_VERSION=0.33.0
ARG LIBRESPOT_VERSION=0.4.0
 
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
    nodejs \
    npm \
    pipewire-audio \
    pipewire-libcamera \
    procps \
    pulseaudio-utils \
    rtkit \
    unzip \
    xvfb \
    xz-utils

RUN <<EOF
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
EOF

FROM base AS runtime
ENV DISABLE_RTKIT=y
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

ENV SNAPSERVER_CODEC=flac
ENV SNAPSERVER_CHUNK_MS=26
ENV SNAPSERVER_BUFFER=1000
ENV SNAPCLIENT_HOSTID=Pipewire-Local
ENV SNAPSERVER_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:$ALSA_PLAYBACK_CHANNELS"
#ENV SNAPSERVER_SOURCE="pipewire://?name=Snapcast&auto_connect=true"
ENV SNAPSERVER_SOURCE="pipe:///tmp/snapfifo?name=pipewire&sampleformat=$SNAPSERVER_SAMPLEFORMAT"
ENV SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"

WORKDIR /root

RUN  mkdir -p /local /etc/bashrc.d /config ./config

COPY ./config/ /root/config/
COPY ./config/asound.conf /etc/asound.conf
COPY ./config/snapserver/snapserver.conf /etc/snapserver.conf

COPY ./startup/ /root/startup/
COPY ./scripts/*.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/*.sh && \
    chmod 755 /root/startup/*.sh && \
    mv /usr/local/bin/bashrc.sh /etc/bashrc.d/bashrc.sh && \
    echo ". /etc/bashrc.d/bashrc.sh" >> /etc/bash.bashrc

CMD ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

