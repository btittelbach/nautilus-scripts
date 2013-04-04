#!/bin/bash
IFS=$'\n'
test -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" && exit 1
FILES=$(sort <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")
DEST=$(common_substring.pl $FILES)
test -z "$DEST" && exit 2
test -e "$DEST" && exit 3
cat $FILES > "$DEST"
