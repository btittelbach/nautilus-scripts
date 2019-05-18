#!/bin/zsh
for f in "${${(f)NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}[@]}"; do
    gio rename "${f}" "$(date +%Y-%m-%d -r "$f") ${f:t}"
done
