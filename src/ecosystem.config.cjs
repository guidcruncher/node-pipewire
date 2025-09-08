module.exports = {
  apps : [
  {
    name   : "go-librespot",
    cwd    : "/app",
    script : "/usr/local/bin/go-librespot.sh",
    pid_file: "/local/state/go-librespot.pid",
    args   : ""
  },
  {
    name   : "mpd",
    cwd    : "/app",
    script : "/usr/local/bin/mpd.sh",
    pid_file: "/local/state/mpd.pid",
    args   : ""
  },
  {
    name   : "icecast",
    cwd    : "/app",
    script : "/usr/local/bin/icecast.sh",
    pid_file: "/local/state/icecast.pid",
    args   : ""
  },
  {
    name   : "capture-audio",
    cwd    : "/app",
    script : "/usr/local/bin/capture-audio.sh",
    pid_file: "/local/state/capture-audio.pid",
    args   : ""
  },
  ]
}
