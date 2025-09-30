FROM debian:bookworm AS base

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
    xz-utils \
    && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM base AS runtime

WORKDIR /root

RUN  mkdir -p /local /etc/bashrc.d

COPY ./startup/ /root/startup/
COPY ./scripts/*.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/*.sh && \
    chmod 755 /root/startup/*.sh && \
    mv /usr/local/bin/bashrc.sh /etc/bashrc.d/bashrc.sh && \
    echo ". /etc/bashrc.d/bashrc.sh" >> /etc/bash.bashrc

CMD ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

