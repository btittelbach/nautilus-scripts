#!/bin/bash
#echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | zenity --text-info 
#echo $NAUTILUS_SCRIPT_SELECTED_URIS | zenity --text-info 
#FILE=`echo $NAUTILUS_SCRIPT_SELECTED_URIS | cut -d $'\n' -f 1`
IFS=$'\n'
prename 's/(\w)\.(\w)/$1 $2/g; s/S0?(\d+)E(\d\d)/- $1x$2 -/;' $*

