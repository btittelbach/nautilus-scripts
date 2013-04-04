#!/bin/bash
IFS=$'\n'
for f in $NAUTILUS_SCRIPT_SELECTED_URIS; do
ext=".txt"
[ "${f:${#f}-5:1}" == "." ] && ext="${f:${#f}-5:5}"
[ "${f:${#f}-4:1}" == "." ] && ext="${f:${#f}-4:4}"
fname=`basename $f`
name=`basename $f $ext`
pdbpath="${f/%$ext/}.pdb"
ftxt=`mktemp`
fpdb=`mktemp`
gnomevfs-copy "$f" "$ftxt"
if (file -i "${ftxt}" | grep -q "charset=utf-8"); then
  recode utf8..latin1 "${ftxt}"
fi
txt2pdbdoc "${name}" "${ftxt}" "${fpdb}"
gnomevfs-copy "${fpdb}" "${pdbpath}"
rm "${ftxt}" "${fpdb}"
done
