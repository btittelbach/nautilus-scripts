#!/bin/bash
#&>~/post_nzb_script.log
shopt -s extglob
#NZBP_NZBDIR=$1
#NZBP_NZBFILE=$2
#NZBP_DECODEDIR=$3
#NZBP_LASTFILE=$4
echo "$NZBP_NZBDIR"
echo "$NZBP_NZBFILE"
echo "$NZBP_DECODEDIR"
echo "$NZBP_LASTFILE"
echo ""
echo "$TERM"
#test -z "$TERM" && echo ja

test -n "$NZBP_DECODEDIR" && cd "$NZBP_DECODEDIR"

EXTRACTED=0
#ORIG_FILES=$(ls -1 *.@(par2|PAR2|nfo))

shopt -s nullglob
tmpfile=/tmp/$$.tmp
for binfile in *.bin; do
  file "$binfile" | grep "MacBinary III data" >/dev/null
  if [ $? -eq 0 ] ; then
    macunpack -l -d "$binfile" &>"$tmpfile"
    gvfs-trash "$binfile"
    perl -n -e 'if ($_ =~ /name="([^"]+)"/) {qx{mv "$1".data "$1"};}' < "$tmpfile"
    rm "$tmpfile"
  fi
done
shopt -u nullglob
#this is botched, doesn't work if there are
# serveral concat files ab.001 ab.002 cd.001 cd.002 in one directory
CONCATFILES=*.[[:digit:]][[:digit:]][[:digit:]]
CONCATFILESNUM=$(ls -1 $CONCATFILES | wc -l)
# if (( $CONCATFILESNUM > 1 )); then
# 	DEST=$(common_substring.pl $CONCATFILES)
# 	test -z "$DEST" && exit 2
# 	test -e "$DEST" && exit 3
# 	cat $CONCATFILES > "$DEST"
# 	gvfs-trash $CONCATFILES 
# 	EXTRACTED=1
# fi

#this failes horribly for multiple concat files, if there aren't par2's for each
PARFILE=!(*vol+([[:digit:]])\++([[:digit:]])).@(par2|PAR2|par)
PARFILENUM=$(ls -1 $PARFILE | wc -l)
if (( $PARFILENUM > 0 )); then
	for pfile in ${PARFILE}; do
		if [ -e "$pfile" ]; then
			par2repair $( [ -z "$TERM" ] && echo "-q") "$pfile" $CONCATFILES|| exit 4
		fi
	done
	gvfs-trash *.par2 *.PAR2 *.p[[:digit:]][[:digit:]] *.par
    concatresult=true
    shopt -s nullglob
    for ccrf in *.001; do
      test -f "`basename \"$ccrf\" .001`" || concatresult=false
    done
    shopt -u nullglob
    test $concatresult == true && gvfs-trash $CONCATFILES 
fi

shopt -s nullglob
for ccof in *.001; do
  ccrf=`basename "$ccof" .001`
  test -e "$ccrf" && continue
  test -z "$ccrf" && continue
  test -f "$ccrf.rar" && continue
  test -f "$ccrf.7z" && continue
  test -f "$ccrf.zip" && continue
  cat "$ccrf".[[:digit:]][[:digit:]][[:digit:]] > "$ccrf"
  gvfs-trash "$ccrf".[[:digit:]][[:digit:]][[:digit:]] 
done

Z7FILE=*.7z
for z7file in ${Z7FILE}; do
    if [ -e "$z7file" ]; then
        p7zip -d "$z7file"  || exit 5
        EXTRACTED=1
        gvfs-trash "${z7file}"
    fi
done
RARPARTFILE=*.part*(0)1.rar
for rfile in ${RARPARTFILE}; do
    if [ -e "$rfile" ]; then
        rar x -o+ -p- "$rfile"  || exit 5
        EXTRACTED=1
        gvfs-trash "${rfile/%.part*rar/}".part+([[:digit:]]).rar
    fi
done
RARFILE=!(*part+([[:digit:]])).rar
for rfile in ${RARFILE}; do
    if [ -e "$rfile" ]; then
        rar x -o+ -p- "$rfile"  || exit 5
        EXTRACTED=1
        gvfs-trash "${rfile/%.rar/}".@(rar|ra[[:digit:]]|r[[:digit:]][[:digit:]]|[[:digit:]][[:digit:]][[:digit:]])         
    fi
done
ZIPFILE=*.zip
for zfile in ${ZIPFILE}; do
    if [ -e "$zfile" ]; then
        unzip -o "$zfile"  || exit 6
        EXTRACTED=1
        gvfs-trash "${zfile/%.zip/}".@(zip|zi[[:digit:]]|z[[:digit:]][[:digit:]]|[[:digit:]][[:digit:]][[:digit:]]) 
    fi
done

if (($EXTRACTED > 0)); then
	#IFS=$'\n'; gvfs-trash $ORIG_FILES
	#unset IFS
	test -n "$NZBP_NZBFILE" && rm ~/nzb/"$NZBP_NZBFILE"
fi

animerename --ok *
