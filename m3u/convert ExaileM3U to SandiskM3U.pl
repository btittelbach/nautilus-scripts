#!/usr/bin/perl -w
use File::Basename;
use Cwd 'abs_path';
for (my $argnum=0; $argnum < scalar(@ARGV); $argnum++)
{
  my $filenamei = basename($ARGV[$argnum]);
  my $filedir  = dirname($ARGV[$argnum]);
  my $filenameo=".tmp.".$filenamei;
  open($fhi, "<". $filedir."/".$filenamei);
  open($fho, ">". $filedir."/".$filenameo);
  #my $cwd = abs_path($filedir)."/";
  my $cwd ='/home/bernhard/mnt/mp3server/';
  while (<$fhi>)
  {
    $_=~s/^file:\/\/$cwd//;
    $_=~s/\%(\X\X)/chr(hex($1))/exg;
    print $fho $_;
  }
  close($fhi);
  close($fho);
  rename($filedir."/".$filenameo, $filedir."/".$filenamei);
}