#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.1 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>            |
# | getdata.cgi                                                                |
# | CGI program                                                                |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

use lib 'cgi-bin';
use Switch;
use Scalar::Util qw(looks_like_number);

$contname = 'MM8D/RPI';
$contversion = 'v0.1';

# get data
local ($buffer, @pairs, $pair, $name, $value, %FORM);
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "GET")
{
  $buffer = $ENV{'QUERY_STRING'};
}

$buffer = 'channel=1&uid=0&value=1';

# split input data
@pairs = split(/&/, $buffer);
foreach $pair (@pairs)
{
  ($name, $value) = split(/=/, $pair);
  $value =~ tr/+/ /;
  $value =~ s/%(..)/pack("C", hex($1))/eg;
  $FORM{$name} = $value;
}
$channel = $FORM{channel};
$uid = $FORM{uid};
$value = $FORM{value};

# load configuration
#$conffile = "/etc/mm8d/mm8d.ini";
#$conffile = "/usr/local/etc/mm8d/mm8d.ini";
$conffile = "./mm8d.ini";
open CONF, "< $conffile" or die "ERROR: Cannot open ",$conffile," configuration file!";
while (<CONF>)
{
  chop;
  my(@columns) = split("=");
  my($colnum) = $#columns;
  $row = "";
  foreach $colnum (@columns)
  {
    $row = $row . $colnum;
  }
  my(@datarow) = split("\"\"",$row);
  my($datarownum) = $#datarow;
  switch ($columns[0])
  {
    case "dir_lck" { $dir_lck = $columns[1]; }
    case "dir_log" { $dir_log = $columns[1]; }
    case "usr_dt1" { $usr_dt1 = $columns[1]; }
    case "usr_dt2" { $usr_dt2 = $columns[1]; }
    case "usr_dt3" { $usr_dt3 = $columns[1]; }
    case "usr_nam" { $usr_nam = $columns[1]; }
    case "usr_uid" { $usr_uid = $columns[1]; }
  }
  my @b = (0..9);
  for (@b)
  {
    if ($columns[0] eq "nam_ch0" . $_)
    {
      $nam_ch[$_] = $columns[1];
    }
  }
  my @b = (10..16);
  for (@b)
  {
    if ($columns[0] eq "nam_ch" . $_)
    {
      $nam_ch[$_] = $columns[1];
    }
  }
}
close CONF;

# create output
$lockfile = "$dir_lck/mm8d.lock";
$datafile = "$dir_log/mm8d-ch";
if ( looks_like_number($channel) && $channel >=0  &&  $channel <= 16 )
{
  if ( $channel >=0  &&  $channel <= 9 )
  {
    $datafile = $datafile . "0" . $channel . ".log";
  }
  else
  {
    $datafile = $datafile . $channel . ".log";
  }
}
else { die "ERROR: Bad channel number!" }
open DATA, "< $datafile" or die "ERROR: Cannot open ",$datafile," log file!";
close DATA;

print "Content-type:text/html\r\n\r\n";

if ( $uid eq $usr_uid )
{
  # check lockfile
  while (-e $lockfile)
  {
    sleep 1;
  }
  if ( $value eq '0' )
  {
    print "$contname\n";
    print "$contversion\n";
    exit 0;
  }
  if ( $value eq '1' )
  {
    print "$usr_nam\n";
    print "$usr_dt1\n";
    print "$usr_dt2\n";
    print "$usr_dt3\n";
    exit 0;
  }
  if ( $value eq '2' )
  {
    open DATA, "< $datafile" or die "Cannot open log file!";
    while (<DATA>)
    {
      chop;
      my(@columns)= split(",");
      my($colnum)=$#columns;
      $row = "";
      foreach $colnum (@columns)
      {
        $row = $row . $colnum;
      }
      my(@datarow) = split("\"\"",$row);
      my($datarownum) = $#datarow;
      print $nam_ch[$channel];
      print "$columns[0]\n";
      print "$columns[1]\n";
      print "$columns[2]\n";
      print "$columns[3]\n";
      print "$columns[4]\n";
      print "$columns[5]\n";
      print "$columns[6]\n";
      print "$columns[7]\n";
      if ( $channel > 0 )
      {
        print "$columns[8]\n";
        print "$columns[9]\n";
        print "$columns[10]\n";
        print "$columns[11]\n";
        print "$columns[12]\n";
        print "$columns[13]\n";
        print "$columns[14]\n";
        print "$columns[15]\n";
      }
      last;
    }
    close DATA;
  }
}
exit 0;
