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
    name   : "snapserver",
    cwd    : "/app",
    script : "/usr/local/bin/snapserver.sh",
    pid_file: "/local/state/snapserver.pid",
    args   : ""
  },
  {
    name   : "snapclient",
    cwd    : "/app",
    script : "/usr/local/bin/snapclient.sh",
    pid_file: "/local/state/snapclient.pid",
    args   : ""
  },
  ]
}
