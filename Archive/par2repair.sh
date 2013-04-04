#!/bin/bash
#FILE=$*
FILE="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
FN=$(basename "$FILE")
cd $(echo $FILE | sed "s/$FN//")
vte -c "par2repair" "$FN"
