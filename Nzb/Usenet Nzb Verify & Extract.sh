#!/bin/bash
export NZBP_NZBDIR=""
export NZBP_NZBFILE=""
export NZBP_LASTFILE=""
shopt -s extglob
NEWSDIR=$HOME/news/
IFS=$'\n'
if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ] ; then
	for nzbfile in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
		export NZBP_NZBDIR=""
		export NZBP_NZBFILE=""
		if [ -f "$nzbfile" -a "${nzbfile:${#nzbfile}-4:4}" = ".nzb" ] ; then
			export NZBP_NZBFILE=${nzbfile/*\//}
			atmp=${NZBP_NZBFILE/msgid_+([[:digit:]])_/}
			export NZBP_DECODEDIR=$NEWSDIR${atmp/%.nzb/}
			if [ -d "$NZBP_DECODEDIR" ] ; then
				mkfifo /tmp/nzblog$$
				cat /tmp/nzblog$$ >>~/.gnome2/nautilus-scripts/.helpers/post_nzb.log &
				~/.gnome2/nautilus-scripts/.helpers/post_nzb_script.sh &>/tmp/nzblog$$ </dev/null
				rm /tmp/nzblog$$
			fi
		fi
	done
fi
