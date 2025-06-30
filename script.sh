#!/bin/bash

AUDIO_DIR="$HOME/repos/thinato/cron-test/audio"

if [ -n "$1" ]; then
  RANDOM_NUMBER="$1"
else
  RANDOM_NUMBER=$(( $RANDOM % 100 + 1 ))
fi

echo "random number: $RANDOM_NUMBER"

if [ "$RANDOM_NUMBER" -gt 25 ]; then
  exit 0
fi

AUDIO_FILES=("$AUDIO_DIR"/*.mp3)

echo "audio files: $AUDIO_FILES"

# If there are no audio files, exit
if [ ${#AUDIO_FILES[@]} -eq 0 ]; then
    echo "No MP3 files found in $AUDIO_DIR. Exiting."
    exit 1
fi

RANDOM_AUDIO_FILE="${AUDIO_FILES[RANDOM % ${#AUDIO_FILES[@]}]}"

echo "selected audio file: $RANDOM_AUDIO_FILE"


if [[ $(uname) == "Darwin" ]]; then
  echo "playing for mac"
  /usr/bin/afplay "$RANDOM_AUDIO_FILE" & disown
elif [[ $(uname) == "Linux" ]]; then
  echo "playing for linux"

  export XDG_RUNTIME_DIR="/run/user/$(id -u)"


  # /usr/bin/ffplay -v 0 -nodisp -autoexit -f pulse -i "$DEFAULT_SINK" "$RANDOM_AUDIO_FILE" >/dev/null 2>&1 & disown 
  /usr/bin/ffplay -v 0 -nodisp -autoexit  "$RANDOM_AUDIO_FILE" >/dev/null 2>&1 & disown    
else
  echo "Unknwon OS"
fi


