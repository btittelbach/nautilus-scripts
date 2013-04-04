#!/bin/bash
IFS=$'\n'
for FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
  gmplayer $(mplayer -vf cropdetect "$FILE" | grep "[CROP]" | cut -d "(" -f 2 | cut -d ")" -f 1 | tail -n 1 ) "$FILE" &>/dev/null
done
