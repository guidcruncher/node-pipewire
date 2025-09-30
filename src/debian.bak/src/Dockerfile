FROM debian:bookworm AS base
ARG TARGETARCH

ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

ENV XDG_CONFIG_HOME=/local/config
ENV XDG_CACHE_HOME=/local/cache
ENV XDG_DATA_HOME=/local/share
ENV XDG_STATE_HOME=/local/state
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV XDG_DATA_DIRS=/usr/local/share:/usr/share
ENV XDG_CONFIG_DIRS=/etc/xdg
ENV SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"
ENV MACHINE_NAME="Pipewire"

RUN <<EOF
mkdir -p /pipewire-config /usr/share/snapserver/snapweb /pipewire-config /usr/local/bin/node-pipewire.d /etc/xdg /usr/local/bin /tmp/logs

mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME \
  $XDG_STATE_HOME $XDG_RUNTIME_DIR /local/.defaults
chmod 700 $XDG_RUNTIME_DIR

mkdir -p /local/config/pm2 /local/.defaults
mkdir -p ${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d \
${XDG_CONFIG_HOME}/pipewire/pipewire-pulse.conf.d \
${XDG_CONFIG_HOME}/pipewire/client.conf.d \
${XDG_CONFIG_HOME}/pipewire/filter-chain.conf.d \
${XDG_CONFIG_HOME}/pipewire/jack.conf.d \
${XDG_CONFIG_HOME}/pm2 \
${PM2_BASE_HOME} ${PM2_CONTAINER_HOME}

apt update
apt install -y --no-install-recommends \
  curl nano ffmpeg gzip unzip jq xz-utils pipewire-audio \
  gettext-base libasound2 avahi-daemon avahi-utils bluez \
  alsa-tools alsa-utils procps libasound2-plugin-equal \
  pulseaudio-utils ca-certificates nodejs npm libpipewire-0.3-dev

apt install -y dbus

npm install -g typescript ts-node tslib @types/node pm2

ln -f -s "/usr/share/zoneinfo/$TZ" '/etc/localtime'
echo "$TZ" | tee /etc/timezone
EOF

FROM base AS prod

ENV PULSE_RUNTIME_PATH=/tmp/pulse/
ENV PIPEWIRE_RUNTIME_DIR=/tmp/
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV XDG_CONFIG_HOME=/local/config
ENV XDG_CACHE_HOME=/local/cache
ENV XDG_DATA_HOME=/local/share
ENV XDG_STATE_HOME=/local/state
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV XDG_DATA_DIRS=/usr/local/share:/usr/share
ENV XDG_CONFIG_DIRS=/etc/xdg
ENV GOLIBRESPOT_API=http://localhost:3678
ENV GOLIBRESPOT_CREDENTIAL_TYPE=zeroconf
ENV SPOTIFY_USERNAME=
ENV SPOTIFY_TOKEN=
ENV SPOTIFY_DEVICE_NAME=Pipewire
ENV SPOTIFY_AUTHJSON=
ENV RTKIT_ENABLE=true
ENV PM2_BASE_HOME=${XDG_STATE_HOME}/pm2/base
ENV PM2_CONTAINER_HOME=${XDG_STATE_HOME}/pm2/container
ENV PM2_HOME=${PM2_CONTAINER_HOME}
ENV ENABLE_SERVICES=go-librespot,snapserver,snapclient
ENV ALSA_PLAYBACK_DEVICE="hw:AUDIO,0"
ENV ALSA_PLAYBACK_RATE=44100
ENV ALSA_PLAYBACK_FORMAT="S16LE"
ENV ALSA_PLAYBACK_CHANNELS=2
ENV ALSA_PLAYBACK_POSITION="FL,FR"
ENV ALSA_BITS_PER_SAMPLE=16
ENV SNAPSERVER_DATADIR=/local/config/snapserver/
ENV SNAPSERVER_CODEC=flac
ENV SNAPSERVER_CHUNK_MS=26
ENV SNAPSERVER_BUFFER=1000
ENV SNAPCLIENT_HOSTID=Pipewire-Local
ENV SNAPSERVER_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:$ALSA_PLAYBACK_CHANNELS"
ENV SNAPSERVER_SOURCE="pipewire://?name=Snapcast&auto_connect=true"
# "pipe:///tmp/snapfifo?name=pipewire&sampleformat=$SNAPSERVER_SAMPLEFORMAT"
ENV SNAPCLIENT_SAMPLEFORMAT="$ALSA_PLAYBACK_RATE:$ALSA_BITS_PER_SAMPLE:*"
ENV MACHINE_NAME="Pipewire"
ENV DEFAULT_SINK="snapcast-sink"
ENV DEFAULT_SOURCE="alsa-sink.monitor"

COPY ./config/snapserver/snapserver.conf /etc/snapserver.conf
COPY ./config/ ${XDG_CONFIG_HOME}/
COPY ./config/ /local/.defaults/
RUN mkdir -p /local/config/pm2/
COPY ./ecosystem.config.cjs /local/config/pm2
COPY ./config/asound.conf /etc/asound.conf

WORKDIR /app
COPY --chmod=755 ./scripts/*.sh /usr/local/bin/
RUN mkdir -p /etc/bashrc.d && mv /usr/local/bin/bashrc.sh /etc/bashrc.d/ && echo ". /etc/bashrc.d/bashrc.sh" >> /etc/bash.bashrc

CMD ["/usr/local/bin/entrypoint.sh"]

