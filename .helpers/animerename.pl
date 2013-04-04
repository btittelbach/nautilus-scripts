#!/usr/bin/perl -w
# (C) Xro 2002 <xro@gmx.net>

#use Getopt::Long;  
#use File::Listing; (needed for parse_dir)

#@files = @ARGV;
#@files = qx{ls ./};

#ToDo:
# - Automatically find .gebrannt files and rename Files according to pattern

#Usage:
# animerename <file|directory> [--pattern <filenamepattern>] [--ok]
# Rename is executed only if --ok is supplied
# with --pattern you can supply a Filename, so all supplied files will be rename to look like the supplied pattern

$DEBUG = undef;

sub EXTRARULES {
	my $mask = shift(@_);
	$mask =~ s/\sEps\s/ /;
	$mask =~s/^Logh/Legend Of Galactic Heroes/i;
	$mask =~s/^Tengen Toppa (Gurren Lagann)/$1/i;
	$mask =~s/ SG 1 -/ Sg1 -/i;
	$mask =~s/^Kashimashi(?!\sGirl)/Kashimashi Girl Meets Girl/;
	$mask =~s/^(?:Dr Who|Doctor Who) - 28\s*/Doctor Who 2006 - 2/;
	$mask =~s/^(?:Dr Who|Doctor Who) - 29\s*/Doctor Who 2007 - 3/;
	$mask =~s/^(?:Dr Who|Doctor Who) - 30\s*/Doctor Who 2008 - 4/;
	$mask =~s/^(?:Dr Who|Doctor Who) - 31\s*/Doctor Who 2009 - 5/;
	$mask =~s/^(?:Dr Who|Doctor Who) 2005 - 3\s*/Doctor Who 2007 - 3/;
	$mask =~s/Moonlight Mile/Moonlight Mile/i;
	$mask =~s/Chaos[^ ]Head/Chaos Head/i;
	$mask =~s/Decode S?(\d\D)/Decode 0$1/i;
	$mask =~s/^Mobile Suit Gundam/Gundam/i;
	$mask =~s/^Nijuu Mensou No Musume/The Daughter Of Twenty Faces/i;
	$mask =~s/^Birdy The Mighty/Tetsuwan Birdy/i;
	$mask =~s/^Sora No Oto/Sora No Woto/i;
	$mask =~s/^Densetsu No Yuusha No Densetsu/The Legend Of The Legendary Heroes/i;
	$mask =~s/^Kampfer/Kämpfer/i;
	$mask =~s/^The World God Only Knows/Kami Nomi Zo Shiru Sekai/i;
	$mask =~s/^Panty And Stocking With Garterbelt/Panty & Stocking With Garterbelt/i;
	$mask =~s/^Itsuka Tenma no Kuro.?usagi/A Dark Rabbit Has Seven Lives/i;
	$mask =~s/^Moretsu Pirates/Bodacious Space Pirates/i;
	return $mask;
}

sub repl_fill_chars {
	$_[0] =~ s/_|-|~|\.|​/ /g;
}

sub chopchop {
	$_[0] =~ s/^\s+//;
	$_[0] =~ s/\s+$//; 
	$_[0] =~ s/\s\s+/ /g;
}

$forreal = undef;
@files=(),$pattern=undef;

$torrenty="";
$torrentn=".torrent|";

foreach my $file (@ARGV) {
   if (defined $file and $file ne "") {
	if (-d $file) {
		opendir($dir,$file);
		while (defined ($subfile = readdir($dir)))
		{
			push(@files,"$file/$subfile") unless (-d "$file/$subfile");
		}
	} elsif ($file eq "--ok") {
		$forreal = 1;
#	} elsif ($file eq "--ks") {
#		$ks = 1;
#		for (parse_dir(`ls -l`)) {
#			my ($fname, $ftype, $fsize, $mtime, $fmode) = @$_;
#			#print "$fname	$ftype	$fsize\n";
#			if ($ftype eq 'f' and $fsize == 0 and $fname =~ /(.+)\d{2,3}.*\.(gebrannt|burned)/) {
#				push(@gebrannte,$1);
#			}
#		}
#		print (@gebrannte);
	} elsif ($file eq "--pattern") {
		$pattern = 1;
	} elsif ($file eq "--debug") {
		$DEBUG = 1;
	} elsif (defined $pattern and $pattern eq 1 and $file =~ /(.+)\d{2,3}.*\.(gebrannt|burned|avi|ogm|mpg)/) {
		$pattern=$1;
	} else {
		push(@files,$file);
	}
   }
}

if (!$forreal) {
	print "Only Testing, to execute rename for real add --ok\n";
}

local $main::bracket_info_regex='\[[^\]]+\]|\((?!20[012]\d)[^\)]+\)';
local $main::crc_regex='\[[[:xdigit:]]{8}\]';
local $main::known_info_artefacts_regex='360p|480p|720p|1080p|\d{4}x(768|720|1080)|[xh]264|AAC|DTS|AC3|XviD|DivX|Vorbis';
#local $main::ep_regex='(?<!\d)\d?\dx\d\d|(?<!\d)\d{2,3}-\d{2,3}|Ep(?:isode\D?)?\d{1,3}|(?<!\d)\d{2,3}(?:v\d)?|s\d{2}e\d{2}|part.\d|movie|web|Pilot|Promo|Trailer|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special';
local $main::ep_regex='\d?\dx\d\d|S\d.?-.?\d{2,3}|(?<!\d)\d{2,3}-\d{2,3}|Ep(?:s|isode\D?)?\d{1,3}|(?<!\d)\d{2,3}(?:v\d)?|s\d{2}e\d{2}|part.\d|(?:the )?movie(?:.?\d(?!\d))|web|Pilot|PV|Promo|Trailer|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter).)?Special';
local $main::name_ep_seperator_regex = '\s+|\s*[-_.]\s*';
local $main::ext_regex= '(?:avi|asf|mpg|mpeg|ogm|mp4|ts|wmv|mkv)(?!\.$torrent|\.sfv|\.md5|\.par|\.par2)';

sub regex_name_w_wo_digits
{
	#return 0 unless ($_[0] =~ /^($main::bracket_info_regex)?(.+?(?<!S)\d+(?!-\d))(?:$main::name_ep_seperator_regex)($main::ep_regex)(?!\d)(.*)\.($main::ext_regex)$/ig);
  #return 0 unless ($_[0] =~ /^($main::bracket_info_regex)?(.+?\d+(?!-\d))(?:$main::name_ep_seperator_regex)($main::ep_regex)(?!\d)(.*)\.($main::ext_regex)$/ig);
  my $str = $_[0];
  if ($str =~ s/($main::crc_regex)//) { $_[1]{crc}=$1 } else {$_[1]{crc}=""};
  if ($str =~ s/^($main::bracket_info_regex)//) {$_[1]{grp}=$1} else { $_[1]{grp} = ""};
  $_[1]{nfo} = "";
  while ($str =~ s/($main::bracket_info_regex)//i) { $_[1]{nfo} .= $1;  }
  while ($str =~ s/($main::known_info_artefacts_regex)//i) { $_[1]{nfo} .= "[$1]";  }
	return 0 unless ($str =~ /^(.+?\d+(?!-\d)|.+?(?!\d))(?:$main::name_ep_seperator_regex)($main::ep_regex)(?!\d)(.*)\.($main::ext_regex)$/ig);
	$_[1]{name} = $1 || "";
	$_[1]{ep}=$2 || "";
	$_[1]{nfo} = $3." ".$_[1]{nfo};
	$_[1]{ext} = $4 || "";
	print "regex_name_w_wo_digits\n" if ($main::DEBUG);
	return 1;
}

sub regex_no_ep_number
{
  my $str = $_[0];
  if ($str =~ s/($main::crc_regex)//) { $_[1]{crc}=$1 } else {$_[1]{crc}=""};
  if ($str =~ s/^($main::bracket_info_regex)//) {$_[1]{grp}=$1} else { $_[1]{grp} = ""};
  $_[1]{ep} = "";
  $_[1]{nfo} = "";
  while ($str =~ s/($main::bracket_info_regex)//i) { $_[1]{nfo} .= $1;  }
  while ($str =~ s/($main::known_info_artefacts_regex)//i) { $_[1]{nfo} .= "[$1]";  }
	return 0 unless ($str =~ /^(.+?)(?!\d\s*)\.($main::ext_regex)$/ig);
	$_[1]{name} = $1 || "";
	$_[1]{ext} = $2 || "";
	print "regex_no_ep_number\n" if ($main::DEBUG);
	return 1;
}

sub regex_legacy
{
	return 0 unless ($_[0] =~ /((?:\[|\().+(?:\]|\)))?(.+?)(\[|\.|\s|_|-)((?<!\d)\d?\dx\d\d|(?<!\d)\d{2,3}-\d{2,3}|Ep(?:isode\D?)?\d{1,3}|(?<!\d)\d{2,3}(?:v\d)?|s\d{2}e\d{2}|part.\d|movie(?:.\d)?|web|Pilot|Promo|Trailer|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special)(?!\d)((?:\4|\])?.*)?\.(avi|asf|mpg|mpeg|ogm|mp4|ts|wmv|mkv$torrenty)(?!$torrentn\.sfv|\.md5)$/ig);
	$_[1]{name} = $2 || "";
	$_[1]{ep}=$4 || "";
	$_[1]{grp}=$1 || "";
	$_[1]{nfo} = $5 || "";
	$_[1]{ext} = $6 || "";
  $_[1]{crc} = "";
	print "regex_legacy\n" if ($main::DEBUG);
	return 1;
}
sub regex_test
{
	$_[1]{name} = $_[0];
	$_[1]{ep}="";
	$_[1]{grp}="";
	$_[1]{nfo} ="";
	$_[1]{ext} = "";
  $_[1]{crc} = "";
	print "regex_test\n" if ($main::DEBUG);
	return 1;
}

@functions=(\&regex_name_w_wo_digits,\&regex_no_ep_number,\&regex_legacy);

my $resolutions="400|480|704|720|960|1280|1024|576|888|1080|1440|1920";
foreach my $file (@files) {
	print "------------------------------\n" if ($main::DEBUG);
	$file =~ s/\n//;
	my $prev=$file;

#	my $hash="";
#	if ($file =~ s/(?:\s|_|\[|\()([0-9A-Fa-f]{8})(?:\]|\)|(?=\.))//) {	$hash="[$1]";    }

	$file =~ s/(\w|\d)-(\s)|(\s)-(\w\d)/$1$2/g;

	my $path="";
	if ($file =~ s/^(.*\/)//g) {$path = $1;}

	my %rv=();
	FUNS: foreach my $fun (@functions)
	{
		last FUNS if (&$fun($file,\%rv));
	}
	if (defined $rv{name}) {
		print "name:>$rv{name}<  ep:>$rv{ep}<  grp:>$rv{grp}<  nfo:>$rv{nfo}<  crc:>$rv{crc}<  ext:>$rv{ext}<\n" if ($main::DEBUG);
		if (defined $rv{grp}) {
			if (length($rv{grp}) < 6) { $rv{grp}=uc($rv{grp}); }
			if (length($rv{grp}) > 0) { $rv{grp}=" $rv{grp}"; }
		}
		&repl_fill_chars($rv{grp});
		&chopchop ($rv{grp});
		&repl_fill_chars($rv{nfo});
		&chopchop ($rv{nfo});
		
		$rv{ep} =~ s/^Ep(?:isode\D?)?\s*//i;
		if ($rv{ep} =~ /^(\d)(\d\d)$/ and $rv{ep} > 100 and not $rv{name} =~ /bleach|naruto|fairy tail/i)
		{ $rv{ep} = sprintf("%dx%02d",$1,$2);}
		elsif ($rv{ep} =~ /s(\d{1,2})e(\d{2})/i)
		{ $rv{ep} = sprintf("%dx%02d",$1,$2);}
		elsif ($rv{ep} =~ /(\d{1,2})x(\d{2})/i)
		{ $rv{ep} = sprintf("%dx%02d",$1,$2);}
		elsif ($rv{ep} =~ /S(\d).?-.?(\d{1,2})/i)
		{ $rv{ep} = sprintf("%dx%02d",$1,$2);}
		elsif ($rv{ep} =~ /(\d{1,3})-(\d{1,3})/i)
		{ $rv{ep} = sprintf("%02d-%02d",$1,$2);}
		elsif ($rv{ep} =~ /^\d+$/)
		{ $rv{ep} = sprintf("%02d", $rv{ep}); }
		elsif ($rv{ep} =~ s/^([a-zA-Z]+)(?:\s|\.|\-|\_)?(\d)/$1 $2/) 
		{$rv{ep}=ucfirst($rv{ep}); $rv{ep} =~s/_+|\s+/ /g}

#		if ($rv{grp} eq "") {
#			$rv{nfo} =~ s/(_|\.|\s)+/ /g;
#		} else {
#			$rv{grp} =~ s/(_|\.)/ /g;
#			$rv{nfo} =~ s/(_|-|\[|\]|\.|\s)+/ /g;
#		}
		
		$rv{name} =~ s/(episode|ep(\s|$))//i;
		&repl_fill_chars($rv{name});
		&chopchop($rv{name});
		&chopchop($rv{ep});
		#$rv{name} =~ s/^(\w)/\U$2/;  
		$rv{name} =~ s/([^'äüöß])\b(\w)/$1\U$2/g; #$1 match auf evtl leerzeichen aber nicht auf ', $2 ist der anfangsbuchstabe des neuen wortes
		$rv{name} =~ s/([^']\b\w)(\w{4}\w+)/$1\L$2/g; #bei wörter ab 5 zeichen, soll nur der Anfgangsbuchstabe groß sein
		$rv{name} =~ s/^(\w)/\U$1/g;
		#if ($ks) {
			#check similarity and create appropriate $mask, as in take @gebrannte and just add $rv{ep}$rv{grp}$rv{nfo}
		#} else ... normal $mask
		my ($mask, @filenameparts);
		if    (defined $pattern) { push(@filenameparts,"$pattern$rv{ep}" );     }
    elsif ($rv{ep} ne "")     { push(@filenameparts,"$rv{name} - $rv{ep}");  }
    else                     { push(@filenameparts,$rv{name});              }
		push(@filenameparts,$rv{grp}) unless $rv{grp} eq "";
		push(@filenameparts,$rv{nfo}) unless $rv{nfo} eq "";
		push(@filenameparts,$rv{crc}) unless $rv{crc} eq "";
		$mask = join(" ",@filenameparts).".$rv{ext}";
		$mask = EXTRARULES($mask);
			#debug: $mask = "$rv{name} - $rv{ep} - $rv{grp} - $rv{nfo} - $hash - $rv{ext}";
		if ("$prev" ne "$path$mask") {
			if ($forreal) { renamefile($prev,"$path$mask"); }
			print($prev."\n\t-> $path$mask\n");
		}
	}
}

sub renamefile
{
	my ($from,$to) = @_;
	if (-e "$to")
	{
		print STDOUT "WARNING: $to exists, not renaming $from\n";
		return;
	}
	if (-x "/usr/bin/gnomevfs-mv")
	{
		my @args=("/usr/bin/gnomevfs-mv",$from,$to);
		system(@args); 
	}
	else
	{
		rename($from,$to);
	}

}

#sub getEpisodeNumber
#{
#my $string = shift @_;
#my $match = "";
#my $replace = "";
#
#	if ($string =~ /((?:\[|\().+(?:\]|\)))?.+?\[?(s\d{2}e\d{2})(?!\d)\]?.*$/ig)
#	{
#
#	}
#	elsif ($string =~ /(.*\/)?((?:\[|\().+(?:\]|\)))?(.+?)\[?((?<!\d)0?\dx\d\d|(?<!\d)\d{2}-\d{2}|(?<!\d)\d{2,3}|s\d{2}e\d{2}|movie|web|Pilot|Promo|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special)(?!\d)\]?(.*)\.(avi|asf|mpg|mpeg|ogm|mp4|mkv$torrenty)(?!$torrentn\.sfv|\.md5)$/ig)
#	{
#	}
#	elsif ($string =~ /(.*\/)?((?:\[|\().+(?:\]|\)))?(.+?)\[?((?<!\d)0?\dx\d\d|(?<!\d)\d{2}-\d{2}|(?<!\d)\d{2,3}|s\d{2}e\d{2}|movie|web|Pilot|Promo|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special)(?!\d)\]?(.*)\.(avi|asf|mpg|mpeg|ogm|mp4|mkv$torrenty)(?!$torrentn\.sfv|\.md5)$/ig)
#	{
#	}
#	elsif ($string =~ /(.*\/)?((?:\[|\().+(?:\]|\)))?(.+?)\[?((?<!\d)0?\dx\d\d|(?<!\d)\d{2}-\d{2}|(?<!\d)\d{2,3}|s\d{2}e\d{2}|movie|web|Pilot|Promo|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special)(?!\d)\]?(.*)\.(avi|asf|mpg|mpeg|ogm|mp4|mkv$torrenty)(?!$torrentn\.sfv|\.md5)$/ig)
#	{
#	}
#	elsif ($string =~ /(.*\/)?((?:\[|\().+(?:\]|\)))?(.+?)\[?((?<!\d)0?\dx\d\d|(?<!\d)\d{2}-\d{2}|(?<!\d)\d{2,3}|s\d{2}e\d{2}|movie|web|Pilot|Promo|Teaser|Prologue|(?:(?:spring|summer|x-mas|christmas|winter)\s)?Special)(?!\d)\]?(.*)\.(avi|asf|mpg|mpeg|ogm|mp4|mkv$torrenty)(?!$torrentn\.sfv|\.md5)$/ig)
#	{
#	}
#
#}

