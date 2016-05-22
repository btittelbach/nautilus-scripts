#!/bin/bash
export NZBP_NZBDIR=""
export NZBP_NZBFILE=""
export NZBP_LASTFILE=""
IFS=$'\n'
if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ] ; then
	for dir in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
		if ! [ -d "$dir" ] ; then
			BN=$(basename "$dir")
			export NZBP_DECODEDIR=${dir/%"$BN"/}
		else
			export NZBP_DECODEDIR=${dir}
		fi
		Eterm --pause -e ~/.local/share/nautilus/scripts/.helpers/post_nzb_script.sh &
	done
else
	export NZBP_DECODEDIR="$PWD"
	Eterm --pause -e ~/.local/share/nautilus/scripts/.helpers/post_nzb_script.sh &
fi
