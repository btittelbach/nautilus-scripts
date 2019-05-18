#!/bin/bash
#echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS | zenity --text-info 
#echo $NAUTILUS_SCRIPT_SELECTED_URIS | zenity --text-info 
#FILE=`echo $NAUTILUS_SCRIPT_SELECTED_URIS | cut -d $'\n' -f 1`
IFS=$'\n'
for FILE in $NAUTILUS_SCRIPT_SELECTED_URIS; do
  gio info "${FILE}" | egrep -q "^Error:" && continue
  FPATH=`dirname "${FILE}"`
  DIRNAME=`basename "${FPATH}"`
  EXT=${FILE/*./}
  test -z "${EXT}" && exit 1
  test -z "${DIRNAME}" && exit 2
  test ${#EXT} -gt 4 && exit 3
  DEST="${FPATH}/${DIRNAME}.${EXT}"
  #test -e "${DEST}" && continue
  gio info "${DEST}" | egrep -q "^Error:" || continue
  gio mv "${FILE}" "${DEST}"
done
