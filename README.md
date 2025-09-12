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

A sample docker-compose.yml is included and reproduced below.

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
      - RTKIT_ENABLE=true
      - SPOTIFY_AUTHJSON=
      - SPOTIFY_TOKEN=
      - SPOTIFY_USERNAME=
      - SPOTIFY_DEVICE_NAME=Pipewire
      - TZ=UTC
      - ALSA_PLAYBACK_DEVICE="hw:AUDIO,0"
      - ALSA_PLAYBACK_RATE=48000
      - ALSA_PLAYBACK_FORMAT="S16LE"
      - ALSA_PLAYBACK_CHANNELS=2
      - ALSA_PLAYBACK_POSITION="FL,FR"
    container_name: pipewire
    hostname: pipewire
    restart: unless-stopped
    volumes:
      - ./config:/local/config
      - ./pipewire-config:/pipewire-config
      - type: tmpfs
        target: /tmp
        tmpfs:
          mode: 0o01777
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

Using a host network allows the container to be visible to any Spotify Clients as a speaker device.

## Variables

The environment variables below are comfigurable.

| Name                        | Readonly | Default  | Description                                                                     |
|-----------------------------|----------|----------|---------------------------------------------------------------------------------|
| ALSA_PLAYBACK_DEVICE        | No       |          | ALSA Output device address                                                      |
| ALSA_PLAYBACK_RATE          | No       | 48000    | Playback Output rate                                                            |
| ALSA_PLAYBACK_FORMAT        | No       | S16LE    | Output format                                                                   |
| ALSA_PLAYBACK_CHANNELS      | No       | 2        | Number of playback channels                                                     |
| ALSA_PLAYBACK_POSITION      | No       | FL,FR    | Channel to position mapping (Comma Seperated)                                   |
| GOLIBRESPOT_API             | Yes      |          | The go-librespot API base url                                                   |
| GOLIBRESPOT_CREDENTIAL_TYPE | No       | zeroconf | zeroconf or spotify_token                                                       |
| ICECAST_BITRATE             | No       | 48000    | Icecast bitrate                                                                 |
| ICECAST_CHANNELS            | No       | 2        | Icecast channels                                                                |
| ICECAST_COMPLEVEL           | No       | 5        | Icecast compression level (1-10)                                                |
| ICECAST_ENABLE              | No       | true     | Enable Icecast                                                                  |
| ICECAST_SAMPLERATE          | No       | 48000    | Icecast sample rate                                                             |
| MPD_SOCKET                  | Yes      |          | MPD Control socket path                                                         |
| RTKIT_ENABLE  v             | No       | true     | Set to true to enable RTKit                                                     |
| SPOTIFY_AUTHJSON            | No       |          | Filename of JSON file containing access token and username (spotify_token type) |
| SPOTIFY_TOKEN               | No       |          | Spotify Access token (spotify_token type)                                       |
| SPOTIFY_USERNAME            | No       |          | Spotify username (spotify_token type)                                           |
| SPOTIFY_DEVICE_NAME         | No       | Pipewire | Device name as it appears to other Spotify clients                              |
| TZ                          | No       | UTC      | Timezone                                                                        |
| MACHINE_NAME                | No       | Pipewire | A friendly name for a device on Bluetooth |

Custom Pipewire configuration can be injected via the /pipewire-config bind. Note this overrides any default configuration or values 
set by environment variables.

```bash
pipewire.conf.d
pipewire-pulse.conf.d
client.conf.d
filter-chain.conf.d
jack.conf
```
