#!/bin/zsh
for f in "${${(f)NAUTILUS_SCRIPT_SELECTED_URIS}[@]}"; do
    #echo gio rename "${f}" "$(date +%Y-%m-%d) ${f:t}" | zenity --text-info
    gio rename "${f}" "$(date +%Y-%m-%d) ${f:t}"
done
