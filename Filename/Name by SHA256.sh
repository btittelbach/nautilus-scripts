#!/bin/zsh
type sha256sum &>/dev/null || exit 1
type gio &>/dev/null || exit 1
for f in "${${(f)NAUTILUS_SCRIPT_SELECTED_URIS}[@]}"; do
  local hashname="$(gio cat "${f}" | sha256sum | cut -d' ' -f 1).${f#*.}"
  [[ -n $hashname ]] && gio rename "${f}" "${hashname}"
done
