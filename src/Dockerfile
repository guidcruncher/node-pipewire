FROM alpine:latest AS base
ARG TARGETARCH
ARG NODE_VERSION=24

ENV DISPLAY=:0
ENV PULSE_RUNTIME_PATH=/tmp/pulse/
ENV DISABLE_RTKIT=y
ENV PIPEWIRE_RUNTIME_DIR=/tmp/
ENV TZ=UTC

ENV XDG_CONFIG_HOME=/local/config
ENV XDG_CACHE_HOME=/local/cache
ENV XDG_DATA_HOME=/local/share
ENV XDG_STATE_HOME=/local/state
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV XDG_DATA_DIRS=/usr/local/share:/usr/share
ENV XDG_CONFIG_DIRS=/etc/xdg

RUN <<EOF
mkdir -p /etc/xdg /usr/local/bin /tmp/runtime/mpd

mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME \
  $XDG_STATE_HOME $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
EOF

COPY ./config/ ${XDG_CONFIG_HOME}/
COPY --chmod=755 ./update-golibrespot.sh /usr/local/bin/update-golibrespot.sh

RUN <<EOF
mv $XDG_CONFIG_HOME/asound.conf /etc/asound.conf

mkdir -p /etc/runlevels/default /etc/runlevels/sysinit \
  /etc/runlevels/boot /etc/runlevels/shutdown \
  /etc/runlevels/hotplugged /etc/runlevels/manual

apk update
apk -U --no-cache add util-linux dbus dbus-x11 openrc mdevd-openrc \
  pipewire wireplumber pipewire-pulse pipewire-jack pipewire-alsa \
  alsa-tools alsa-utils alsaconf libpulse avahi libgcc gcompat alsa-lib \
  alsa-plugins mpd mpc ffmpeg \
  curl nano jq xz gzip nodejs-current npm

sed -i '/getty/d' /etc/inittab

/usr/local/bin/update-golibrespot.sh
npm install -g typescript ts-node tslib @types/node pm2
EOF

WORKDIR /app
COPY --chmod=755 ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chmod=755 ./pipewire-launcher.sh /usr/local/bin/pipewire-launcher.sh
COPY --chmod=755 ./mpc.sh /usr/local/bin/mpc.sh
COPY --chmod=755 ./update-golibrespot.sh /usr/local/bin/update-golibrespot.sh
COPY --chmod=755 ./dbus.sh /etc/profile.d/dbus.sh
COPY --chmod=755 ./mpd /etc/init.d/mpd

CMD ["/usr/local/bin/entrypoint.sh"]
