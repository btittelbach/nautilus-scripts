#!/usr/bin/perl -w
use String::CRC32;

sub chopchop {
	$_[0] =~ s/^\s+//;
	$_[0] =~ s/\s+$//; 
	$_[0] =~ s/\s\s+/ /g;
}

$main::ECODE=0;
@files=();

foreach my $file (@ARGV) {
   if (defined $file and $file ne "") 
  {
	if (-d $file) {
		opendir($dir,$file);
		while (defined ($subfile = readdir($dir)))
		{
			push(@files,"$file/$subfile") unless (-d "$file/$subfile");
		}
	} else {
		push(@files,$file);
	}
  }
}

#local $main::ep_regex='(?<!\d)\d?\dx\d\d|(?<!\d)\d{2,3}-\d{2,3}|Ep(?:isode\D?)?\d{1,3}|(?<!\d)\d{2,3}(?:v\d)?|s\d{2}e\d{2}|part.\d|movie|web|Pilot|Promo|Trailer|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special';
local $main::ext_regex= '(?:avi|asf|mpg|mpeg|ogm|mp4|ts|wmv|mkv)(?!\.$torrent|\.sfv|\.md5|\.par|\.par2)';

foreach my $file (@files) {
  if ($file =~ /\[([[:xdigit:]]{8})\].*$main::ext_regex/)
  {
    $crc_filename=hex($1);
    open(SOMEFILE, $file);
    $crc_file = crc32(*SOMEFILE);
    close(SOMEFILE);
    printf "%s: CRC32 (%x =? %x) %s\n", $file, $crc_filename, $crc_file, (($crc_filename == $crc_file)? "OK" :"Failed");
    $main::ECODE = 1 if $crc_filename != $crc_file;
  }
}

exit($main::ECODE)

