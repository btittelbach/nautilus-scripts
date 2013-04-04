#!/bin/bash
IFS=$'\n'
file ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS} | zenity --text-info