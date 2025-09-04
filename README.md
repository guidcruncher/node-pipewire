# node-pipewire

An Alpine Docker image running

- Dbus
- Pipewire
- Wireplumber
- Pipewire Pulseaudio
- MPD
- Icecast2
- go-libresppt
- NodeJS + Typescript

## Getting started

A sammple docker-compose.yml is included.

You can mount the configuration folder by applying a bind mount to /local/config to obtain all the configuration files. 

This bind mount maps directly to the XDG_CONFIG_HOME folder within the container so it holds the configuration for all the applications.

```yaml
services:
  pipewire:
    image: guidcruncher/node-pipewire:latest
    network_mode: host
    environment:
      - GOLIBRESPOT_CREDENTIAL_TYPE=zeroconf
      - ICECAST_BITRATE=48000
      - ICECAST_CHANNELS=2
      - ICECAST_COMPLEVEL=5
      - ICECAST_ENABLE=true
      - ICECAST_SAMPLERATE=48000
      - SPOTIFY_AUTHJSON=
      - SPOTIFY_TOKEN=
      - SPOTIFY_USERNAME=
      - TZ=UTC
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
This image has rtkit enabled, therefore the mentioned capabilities are reccomended.

## Variables

The environment variables below are comfigurable.

| Name                        | Readonly | Default  | Description                                                                     |
|-----------------------------|----------|----------|---------------------------------------------------------------------------------|
| GOLIBRESPOT_API             | Yes      |          | The go-librespot API base url                                                   |
| GOLIBRESPOT_CREDENTIAL_TYPE | No       | zeroconf | zeroconf or spotify_token                                                       |
| ICECAST_BITRATE             | No       | 48000    | Icecast bitrate                                                                 |
| ICECAST_CHANNELS            | No       | 2        | Icecast channels                                                                |
| ICECAST_COMPLEVEL           | No       | 5        | Icecast compression level (1-10)                                                |
| ICECAST_ENABLE              | No       | true     | Enable Icecast                                                                  |
| ICECAST_SAMPLERATE          | No       | 48000    | Icecast sample rate                                                             |
| MPD_SOCKET                  | Yes      |          | MPD Control socket path                                                         |
| SPOTIFY_AUTHJSON            | No       |          | Filename of JSON file containing access token and username (spotify_token type) |
| SPOTIFY_TOKEN               | No       |          | Spotify Access token (spotify_token type)                                       |
| SPOTIFY_USERNAME            | No       |          | Spotify username (spotify_token type)                                           |
| TZ                          | No       | UTC      | Timezone                                                                        |
