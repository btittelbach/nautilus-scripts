#!/bin/zsh
IFS=$'\n'
for f in $NAUTILUS_SCRIPT_SELECTED_URIS; do
  name=$(echo -n ${f:t:r} | perl -n -e '$_=~s/(?<!%)%([0-9A-Fa-f]{2})(?{$subs=chr(hex($^N))})/$subs/g; print$_')
  pdbpath="${f:r}.pdb"
  fpdb=`mktemp`
  fhtml=$(mktemp)
  gnomevfs-copy "$f" "$fhtml"
  txt2pdbdoc "${name}" =(html2pdbtxt "${fhtml}") "${fpdb}"
  gnomevfs-copy "${fpdb}" "${pdbpath}"
  rm "${fhtml}" "${fpdb}"
done
