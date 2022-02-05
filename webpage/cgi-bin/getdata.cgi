#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.2 * Growing house controlling and remote monitoring device         |
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
use strict;
use warnings;

my $contname = 'MM8D';
my $contversion = 'v0.2';
my $conffile;
if (USRLOCALDIR eq 1)
{
  $conffile = "/usr/local/etc/mm8d/mm8d.ini";
} else
{
  $conffile = "/etc/mm8d/mm8d.ini";
}

print "Content-type:text/plain\r\n\r\n";

# get data
my $buffer;
my @pairs;
my $pair;
my $name;
my $channel;
my $uid;
my $value;
my $format;
my %FORM;
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "GET")
{
  $buffer = $ENV{'QUERY_STRING'};
}
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
$format = $FORM{type};
if (($channel eq '') || ($uid eq '') || ($value eq ''))
{
  print "ERROR #9\n";
  print "Usage: getdata.cgi?uid=...&channel=...&value=...\n";
  print "       getdata.cgi?uid=...&channel=...&value=...&type=xml\n";
  exit 9;
}

# load configuration
my $row;
my $dir_lck;
my $dir_log;
my $dir_var;
my $usr_dt1;
my $usr_dt2;
my $usr_dt3;
my $usr_nam;
my $usr_uid;
my @nam_ch;
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
      case "dir_var" { $dir_var = $columns[1]; }
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
my $lockfile = "$dir_lck/mm8d.lock";
my $logfile = "$dir_log/mm8d-ch";
my $ch;
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
    if ( $format eq 'xml' )
    {
      print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
      print "<xml>\n";
      print "  <about>\n";
      print "    <name>$contname</name>\n";
      print "    <version>$contversion</version>\n";
      print "  </about>\n";
      print "</xml>\n";
      exit 0;
    } else
    {
      print "$contname\n";
      print "$contversion\n";
      exit 0;
    }
  }
  if ( $value eq '1' )
  {
    if ( $format eq 'xml' )
    {
      print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
      print "<xml>\n";
      print "  <user>\n";
      print "    <name>$usr_nam</name>\n";
      print "    <data1>$usr_dt1</data1>\n";
      print "    <data2>$usr_dt2</data2>\n";
      print "    <data3>$usr_dt3</data3>\n";
      print "  </user>\n";
      print "</xml>\n";
      exit 0;
    } else
    {
      print "$usr_nam\n";
      print "$usr_dt1\n";
      print "$usr_dt2\n";
      print "$usr_dt3\n";
      exit 0;
    }
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
        if ( $format eq 'xml' )
        {
          print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
          print "<xml>\n";
          print "  <channel>\n";
          print "    <title>$nam_ch[$ch]</title>\n";
          print "  </channel>\n";
          if ( $ch < 1 )
          {
            print "  <status>\n";
            print "    <date>$columns[0]</date>\n";
            print "    <time>$columns[1]</time>\n";
            print "    <voltagesensor>$columns[2]</voltagesensor>\n";
            print "    <overcurrentbreaker1>$columns[2]</overcurrentbreaker1>\n";
            print "    <overcurrentbreaker2>$columns[3]</overcurrentbreaker2>\n";
            print "    <overcurrentbreaker3>$columns[4]</overcurrentbreaker3>\n";
            print "    <overcurrentbreaker4>$columns[5]</overcurrentbreaker4>\n";
            print "  </status>\n";
            print "</xml>\n";
          } else
          {
            print "  <environment>\n";
            print "    <date>$columns[0]</date>\n";
            print "    <time>$columns[1]</time>\n";
            print "    <temperature>$columns[2]</temperature>\n";
            print "    <humidity>$columns[3]</humidity>\n";
            print "    <unwantedgas>$columns[4]</unwantedgas>\n";
            print "    <operationmode>$columns[5]</operationmode>\n";
            print "    <manualmode>$columns[6]</manualmode>\n";
            print "    <overcurrentbreaker>$columns[7]</overcurrentbreaker>\n";
            print "    <alarm>$columns[8]</alarm>\n";
            print "    <lamp>$columns[9]</lamp>\n";
            print "    <ventilator>$columns[10]</ventilator>\n";
            print "    <heater>$columns[11]</heater>\n";
            print "  </environment>\n";
            print "</xml>\n";
          }
        } else
        {
          print $nam_ch[$ch] . "\n";

          my @b = (0..5);
          for (@b)
          {
            print "$columns[$_]\n";
          }
          if ( $ch > 0 )
          {
            my @b = (6..11);
            for (@b)
            {
              print "$columns[$_]\n";
            }
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
  if ( $FORM{value} eq '3' )
  {
    if ( $value ne '0' )
    {
      my $out1;
      my $out2;
      my $out3;
      my $out1file = "$dir_var/$ch/out1";
      my $out2file = "$dir_var/$ch/out2";
      my $out3file = "$dir_var/$ch/out3";
      open DATA, "< $out1file" or $out1 = "neutral";
      my $o1 = <DATA>;
      close DATA;
      switch ($o1)
      {
        case "neutral" { $out1 = "neutral"; }
        case "on" { $out1 = "on"; }
        case "off" { $out1 = "off"; }
      }
      open DATA, "< $out2file" or $out2 = "neutral";
      my $o2 = <DATA>;
      close DATA;
      switch ($o2)
      {
        case "neutral" { $out2 = "neutral"; }
        case "on" { $out2 = "on"; }
        case "off" { $out2 = "off"; }
      }
      open DATA, "< $out3file" or $out3 = "neutral";
      my $o3 = <DATA>;
      close DATA;
      switch ($o3)
      {
        case "neutral" { $out3 = "neutral"; }
        case "on" { $out3 = "on"; }
        case "off" { $out3 = "off"; }
      }
      if ( $FORM{type} eq 'xml' )
      {
        print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
        print "<xml>\n";
        print "  <channel>\n";
        print "    <title>$nam_ch[$ch]</title>\n";
        print "  </channel>\n";
        print "  <override>\n";
        print "    <lamp>$out1</lamp>\n";
        print "    <ventilator>$out2</ventilator>\n";
        print "    <heater>$out3</heater>\n";
        print "  </override>\n";
        print "</xml>\n";
      } else
      {
        print $nam_ch[$ch] . "\n";
        print "$out1\n";
        print "$out2\n";
        print "$out3\n";
      }
      exit 0;
    }
  }
} else
{
  print "ERROR #11\n";
  print "Bad UID value!\n";
  exit 11;
}
exit 0;
