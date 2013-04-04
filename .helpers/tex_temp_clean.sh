#!/bin/bash
# (C) Bernhard Tittelbach
shopt -s extglob
IFS=$'\n'; for tex in $(find -xdev -name "*.tex" ) ; do rm -v -f ${tex/%\.tex/.@(log|toc|aux|nav|snm|out|tex.backup|tex~|bbl|blg|bib.backup|vrb|lof|lot|hd|idx|bib~)}; done

