# node-pipewire

An Alpine Docker image running

- Dbus
- Pipewire
- Wireplumber
- Pipewire Pulseaudio
- MPD
- go-libresppt
- NodeJS + Typescript

## Starting

A sammple docker-compose.yml is included.

You can mount the configuration folder by applying a bind mount to /local/config to obtain all the configuration files. 

This bind mount maps directly to the XDG_CONFIG_HOME folder within the container so it holds the configuration for all the applications.

```yaml
services:
  pipewire:
    image: guidcruncher/node-pipewire:latest
    network_mode: host
    environment:
      - TZ=Europe/London
    container_name: pipewire
    hostname: pipewire
    restart: unless-stopped
    volumes:
      - ./config:/local/config
    devices:
      - /dev/snd:/dev/snd:rw
    privileged: true
    cap_add:
      - SYS_NICE
      - CAP_IPC_LOCK
      - CAP_NET_ADMIN
      - SYS_RAWIO
```
