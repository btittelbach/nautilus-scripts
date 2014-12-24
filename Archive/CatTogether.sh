#!/bin/zsh
IFS=$'\n'
[[ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]] && exit 1
FILES=("${(f)NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}")
DEST=$(common_substring.pl $FILES)
[[ -z $DEST || -e $DEST ]] && exit 2
cat $FILES > "$DEST"
