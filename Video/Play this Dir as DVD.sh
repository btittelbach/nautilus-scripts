#!/bin/bash
P=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | cut -d$'\n' -f 1`
if [ ! -d "$P" ]; then
  zenity --warning --text="$P is not a directory"
  exit 1
fi
cd "$P"
gmplayer -dvd-device ./ dvd://
#vlc ./

