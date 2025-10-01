#/bin/sh

input="pulse"
device="default"
format="ogg"
contenttype="audio/ogg"
codec="flac"

/usr/bin/ffmpeg -f "$input" \
         -i "$device" \
         -ar "$ICECAST_SAMPLERATE" \
         -ac "$ICECAST_CHANNELS" \
         -b:a "$ICECAST_BITRATE" \
         -c:a "$codec" \
         -compression_level "$ICECAST_COMPLEVEL" \
         -f "$format" \
         -content_type "$contenttype" \
         icecast://source:pass@localhost:8000/audio-stream
