FROM alpine:latest AS base
ARG TARGETARCH
ARG NODE_VERSION=24

ENV DISPLAY=:0
ENV PULSE_RUNTIME_PATH=/tmp/pulse/
ENV PIPEWIRE_RUNTIME_DIR=/tmp/
ENV TZ=UTC

ENV XDG_CONFIG_HOME=/local/config
ENV XDG_CACHE_HOME=/local/cache
ENV XDG_DATA_HOME=/local/share
ENV XDG_STATE_HOME=/local/state
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV XDG_DATA_DIRS=/usr/local/share:/usr/share
ENV XDG_CONFIG_DIRS=/etc/xdg
ENV MPD_SOCKET=/local/state/mpd/socket
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

ENV ENABLE_SERVICES=go-librespot,mpd,icecast,capture-audio
ENV ICECAST_CHANNELS=2
ENV ICECAST_SAMPLERATE=48000
ENV ICECAST_COMPLEVEL=5
ENV ICECAST_BITRATE=48000

ENV ALSA_PLAYBACK_DEVICE="hw:AUDIO,0"
ENV ALSA_PLAYBACK_RATE=48000
ENV ALSA_PLAYBACK_FORMAT="S16LE"
ENV ALSA_PLAYBACK_CHANNELS=2
ENV ALSA_PLAYBACK_POSITION="FL,FR"

ENV MACHINE_NAME="Pipewire"

RUN <<EOF
addgroup -S appgroup -g 1001
addgroup -S pipewire
addgroup -S rtkit
addgroup -S sudo
getent group sudo
adduser -S appuser -u 1001 -G sudo  -G rtkit -G pipewire -G appgroup  -h /home/appuser -D

mkdir -p /pipewire-config /usr/local/bin/node-pipewire.d /etc/xdg /usr/local/bin /local/state/mpd /tmp/logs
chown appuser:appgroup /tmp/logs

mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME \
  $XDG_STATE_HOME $XDG_RUNTIME_DIR /local/.defaults
chmod 700 $XDG_RUNTIME_DIR

mkdir -p /usr/lib/ladspa/ /local/config/pm2 /local/.defaults
mkdir -p ${XDG_CONFIG_HOME}/pipewire/pipewire.conf.d \
${XDG_CONFIG_HOME}/pipewire/pipewire-pulse.conf.d \
${XDG_CONFIG_HOME}/pipewire/client.conf.d \
${XDG_CONFIG_HOME}/pipewire/filter-chain.conf.d \
${XDG_CONFIG_HOME}/pipewire/jack.conf.d \
${XDG_CONFIG_HOME}/pm2 \
${PM2_BASE_HOME} ${PM2_CONTAINER_HOME}
EOF


COPY ./config/ ${XDG_CONFIG_HOME}/
COPY ./config/ /local/.defaults/
COPY --chmod=755 ./update-golibrespot.sh /usr/local/bin/update-golibrespot.sh
COPY ./alsa-lib/ /usr/lib/als
COPY ./ladspa/ /usr/lib/ladspa/
RUN mkdir -p /local/config/pm2/
COPY ./ecosystem.config.cjs /local/config/pm2


RUN <<EOF
cp /local/.defaults/asound.conf /etc/asound.conf

mkdir -p /etc/runlevels/default /etc/runlevels/sysinit \
  /etc/runlevels/boot /etc/runlevels/shutdown \
  /etc/runlevels/hotplugged /etc/runlevels/manual

apk update
apk -U --no-cache add util-linux dbus dbus-x11 openrc mdevd-openrc sudo \
  pipewire wireplumber pipewire-pulse pipewire-jack pipewire-alsa \
  pipewire-tools libcamera rtkit pipewire-spa-bluez pipewire-spa-tools \
  alsa-tools alsa-utils alsaconf libpulse avahi libgcc gcompat alsa-lib \
  alsa-plugins mpd mpc ffmpeg ffplay icecast bluez \
  curl nano jq xz gzip nodejs-current npm tzdata su-exec envsubst

adduser root lp
adduser appuser lp

mkdir -p /run/openrc
touch /run/openrc/softlevel

echo "%sudo ALL = (ALL) NOPASSWD: ALL " >/etc/sudoers.d/nopasswd
echo "Defaults exempt_group = sudo " >>/etc/sudoers.d/nopasswd

sed -i '/getty/d' /etc/inittab

/usr/local/bin/update-golibrespot.sh
npm install -g typescript ts-node tslib @types/node pm2

mkdir -p /local/share/icecast2/logs
cp /usr/share/icecast/* /local/share/icecast2/ -r
chown appuser:appgroup /local/share/icecast2 -R

ln -f -s "/usr/share/zoneinfo/$TZ" '/etc/localtime'
echo "$TZ" | tee /etc/timezone
EOF

WORKDIR /app
COPY ./mime.types /etc/mime.types
COPY --chmod=755 ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chmod=755 ./bootstrap.sh /usr/local/bin/bootstrap.sh
COPY --chmod=755 ./pipewire-launcher.sh /usr/local/bin/pipewire-launcher.sh
COPY --chmod=755 ./mpc.sh /usr/local/bin/mpc.sh
COPY --chmod=755 ./update-golibrespot.sh /usr/local/bin/update-golibrespot.sh
COPY --chmod=755 ./dbus.sh /etc/profile.d/dbus.sh
COPY --chmod=755 ./capture-audio.sh /usr/local/bin/capture-audio.sh
COPY --chmod=755 ./go-librespot.sh /usr/local/bin/go-librespot.sh
COPY --chmod=755 ./icecast.sh /usr/local/bin/icecast.sh
COPY --chmod=755 ./mpd.sh /usr/local/bin/mpd.sh
COPY --chmod=755 ./alsa-capabilities.sh /usr/local/bin/alsa-capabilities.sh
COPY --chmod=755 ./pm2.sh /usr/local/bin/pm2.sh
COPY --chmod=755 ./pm2base.sh /usr/local/bin/pm2base.sh


CMD ["/usr/local/bin/entrypoint.sh"]

