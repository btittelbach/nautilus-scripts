#!/usr/bin/perl
#
# Nautilus Script:
#   Show the current directory's XML metafile.
#
# Owner: 
#   Barak Korren
#   ifireball@yahoo.com
#
# Licence: GNU GPL
# Copyright (C) Barak Korren
#
# Dependency:
#   zenity, xmllint, xmessage
#
# Change log:
#   Mon, Apr 05, 2004 - Created.
#
# Known Issues:
#   I'd like to use zentity instead of xmessage, but it doesn't currently 
#   support showing text from the standard input, too bad gless doesn't seem 
#   to be shipped with gnome-utils anymore, maybe one can use the builtin 
#   Nautilus text viewer?
#

sub urlify($) {
	my $str = shift;
	$str =~ s/([\/% ])/sprintf("%%%X", ord($1))/eg;
	return $str;
}

$MFN = $ENV{'NAUTILUS_SCRIPT_CURRENT_URI'} 
	or die('This script must be run from Nautilus!');
$MFN = $ENV{'HOME'} . "/.nautilus/metafiles/" . urlify($MFN) . ".xml";

if ( -r $MFN ) {
	exec "xmllint --format $MFN | xmessage -file -";
}
else {	
	exec "zenity --error --text='Not Found:\n $MFN'";
}
