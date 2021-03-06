#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.1 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | getdata.cgi                                                                |
# | Get data in plain text format                                              |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit
#   1: cannot open configuration file
#   5: cannot open log file
#   9: no parameter(s)
#  10: bad channel value
#  11: bad UID value

use constant USRLOCALDIR => 1;

use lib 'cgi-bin';
use Switch;
use Scalar::Util qw(looks_like_number);

$contname = 'MM8D';
$contversion = 'v0.1';
if (USRLOCALDIR eq 1)
{
  $conffile = "/usr/local/etc/mm8d/mm8d.ini";
} else
{
  $conffile = "/etc/mm8d/mm8d.ini";
}

print "Content-type:text/plain\r\n\r\n";

# get data
local ($buffer, @pairs, $pair, $name, $value, %FORM);
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "GET")
{
  $buffer = $ENV{'QUERY_STRING'};
}

# test data
#buffer = 'channel=1&uid=00000000&value=2';

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
if (($channel eq '') || ($uid eq '') || ($value eq ''))
{
  print "ERROR #9\n";
  print "Usage: getdata.cgi?uid=...&channel=...&value=...\n";
  exit 9;
}

# load configuration
if (-e $conffile)
{
  open CONF, "< $conffile";
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
    my @b = (0..8);
    for (@b)
    {
      if ($columns[0] eq "nam_ch" . $_)
      {
        $nam_ch[$_] = $columns[1];
      }
    }
  }
  close CONF;
} else
{
  print "ERROR #1\n";
  print "Cannot open ",$conffile," configuration file!\n";
  exit 1;
}

# create output
$lockfile = "$dir_lck/mm8d.lock";
$logfile = "$dir_log/mm8d-ch";
if ( looks_like_number($channel) && $channel >=0  &&  $channel <= 8 )
{
  $ch = $channel;
} else
{
  print "ERROR #10\n";
  print "Bad channel value!\n";
  exit 10;
}
$logfile = $logfile . $ch . ".log";
if ( $uid eq $usr_uid )
{
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
    if (-e $logfile)
    {
      open DATA, "< $logfile";
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
        print $nam_ch[$channel] . "\n";
        my @b = (0..7);
        for (@b)
        {
          print "$columns[$_]\n";
        }
        if ( $channel > 0 )
        {
          my @b = (8..15);
          for (@b)
          {
            print "$columns[$_]\n";
          }
        }
        last;
      }
    close DATA;
    } else
    {
      print "ERROR #5\n";
      print "Cannot open ",$logfile," log file!\n";
      exit 5;
    }
  }
} else
{
  print "ERROR #11\n";
  print "Bad UID value!\n";
  exit 11;
}
exit 0;
