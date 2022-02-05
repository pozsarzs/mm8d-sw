#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.2 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | getenvirconf.cgi                                                           |
# | CGI program                                                                |
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

use constant USRLOCALDIR => 1;

use lib 'cgi-bin';
use Scalar::Util qw(looks_like_number);
use Switch;
use strict;
use warnings;
use 5.010;
use Config::Tiny;
use Data::Dumper qw(Dumper);

my $ch;
my $channel;
my $conffile;
my $confdir;
my $row;
my $dir_msg;
my $dir_shr;
my $lang;

# get data
my $buffer;
my @pairs;
my $pair;
my $name;
my $value;
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
  $value =~ s/%(..)/pack("C", hex(1))/eg;
  $FORM{$name} = $value;
}
$channel = $FORM{channel};
if ($channel eq '')
{
  print "Content-type:text/plain\r\n\r\n";
  print "ERROR #9\n";
  print "Usage: getenvirconf.cgi?channel=...\n";
  exit 9;
}

# load configuration
if (USRLOCALDIR eq 1)
{
  $conffile = "/usr/local/etc/mm8d/mm8d.ini";
  $confdir = "/usr/local/etc/mm8d";
} else
{
  $conffile = "/etc/mm8d/mm8d.ini";
  $confdir = "/etc/mm8d";
}

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
      case "lng" { $lang = $columns[1]; }
      case "dir_msg" { $dir_msg = $columns[1]; }
      case "dir_shr" { $dir_shr = $columns[1]; }
    }
  }
  close CONF;
} else
{
  print "Content-type:text/plain\r\n\r\n";
  print "ERROR #1:\n";
  print "Cannot open ",$conffile," configuration file!\n";
  exit 1;
}

# load messages
my $msg01 = "MM8D - controlling and monitoring system";
my $msg08 = "Channel";
my $msg36 = "To set environment characteristic, please login into unit via SSH, and use <i>mm8d-editenvirconf</i> command!";
my $msg38 = "Environment characteristic";
my $msg39 = "Growing hyphae";
my $msg40 = "Growing mushroom";
my $msg41 = "heater";
my $msg42 = "humidifier";
my $msg43 = "ventilator";
my $msg44 = "lamp";
my $msg45 = "on";
my $msg46 = "off";
my $msg47 = "minimum";
my $msg48 = "maximum";
my $msg49 = "disable power on";
my $msg50 = "timed";
my $msgfile = "$dir_msg/$lang/mm8d.msg";
open MSG, "< $msgfile";
while(<MSG>)
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
    case "msg01" { $msg01 = $columns[1]; }
    case "msg08" { $msg08 = $columns[1]; }
    case "msg36" { $msg36 = $columns[1]; }
    case "msg38" { $msg38 = $columns[1]; }
    case "msg39" { $msg39 = $columns[1]; }
    case "msg40" { $msg40 = $columns[1]; }
    case "msg41" { $msg41 = $columns[1]; }
    case "msg42" { $msg42 = $columns[1]; }
    case "msg43" { $msg43 = $columns[1]; }
    case "msg44" { $msg44 = $columns[1]; }
    case "msg45" { $msg45 = $columns[1]; }
    case "msg46" { $msg46 = $columns[1]; }
    case "msg47" { $msg47 = $columns[1]; }
    case "msg48" { $msg48 = $columns[1]; }
    case "msg49" { $msg49 = $columns[1]; }
    case "msg50" { $msg50 = $columns[1]; }
  }
}
close MSG;

if ( looks_like_number($channel) && $channel >0  &&  $channel <= 8 )
{
  $ch = $channel;
} else
{
  print "Content-type:text/plain\r\n\r\n";
  print "ERROR #10\n";
  print "Bad channel value!\n";
  exit 10;
}

# create output
my $footerfile = "$dir_shr/footer_$lang.html";
my $headerfile = "$dir_shr/header_$lang.html";
my $envirconffile = "$confdir/envir-ch$ch.ini";
my $config = Config::Tiny->read( $envirconffile, 'utf8' );
my $section;
my $v;
print "Content-type:text/html\r\n\r\n";
open HEADER, $headerfile;
while (<HEADER>)
{
  chomp;
  print "$_";
}
close HEADER;
# growing hyphae
$section = "hyphae";
print "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"6\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <td colspan=\"2\" class=\"header\" align=\"center\">";
print "            <b class=\"title0\">$msg08 #$ch</b>";
print "          </td>";
print "        </tr>";
print "      </tbody>";
print "    </table>";
print "    <br>";
print "    <b class=\"title1\">$msg38</b><br>";
print "    <br>";
print "    <br>";
print "    <b class=\"title2\">$msg39</b><br>";
print "    <br>";
print "    <table cellspacing=\"0\" border=\"1\">";
print "      <colgroup width=\"115\"></colgroup>";
print "      <colgroup span=\"10\" width=\"55\"></colgroup>";
print "      <tr>";
print "        <td align=\"center\"><b><br></b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg41</b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg42</b></td>";
print "        <td colspan=4 align=\"center\"><b>$msg43</b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg44</b></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\" valign=top><b>$msg45</b></td>";
print "        <td align=\"center\">$config->{$section}{heater_on}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidifier_on}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td align=\"center\">$config->{$section}{vent_on}<br></td>";
print "        <td align=\"center\">m<br></td>";
print "        <td colspan=2 rowspan=4 align=\"center\"><br></td>";
print "        <td align=\"center\">$config->{$section}{light_on1}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg46</b></td>";
print "        <td align=\"center\">$config->{$section}{heater_off}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidifier_off}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td align=\"center\">$config->{$section}{vent_off}<br></td>";
print "        <td align=\"center\">m<br></td>";
print "        <td align=\"center\">$config->{$section}{light_off1}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg45</b></td>";
print "        <td colspan=4 rowspan=2 align=\"center\"><br></td>";
print "        <td colspan=2 rowspan=2 align=\"center\"><br></td>";
print "        <td align=\"center\">$config->{$section}{light_on2}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg46</b></td>";
print "        <td align=\"center\">$config->{$section}{light_off2}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg47</b></td>";
print "        <td align=\"center\">$config->{$section}{temperature_min}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidity_min}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td colspan=4 rowspan=2 align=\"center\"><br></td>";
print "        <td colspan=2 rowspan=28 align=\"center\"><br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg48</b></td>";
print "        <td align=\"center\">$config->{mushroom}{temperature_max}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{mushroom}{humidity_max}<br></td>";
print "        <td align=\"center\">%</td>";
print "      </tr>";
print "      <tr>";
print "        <td rowspan=26 align=\"center\"><b>$msg49</b></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>< $config->{$section}{vent_lowtemp} °C</i></td>";
print "      </tr>";
my @i = (0..23);
for (@i)
{
  print "      <tr>";
  print "        <td align=\"center\">$_</td>";
  $v = "heater_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "humidifier_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "vent_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "vent_disablelowtemp_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "      </tr>";
}
print "    </table>";
print "    <br>";
print "    <br>";
# growing mushroom
$section = "mushroom";
print "    <b class=\"title2\">$msg40</b><br>";
print "    <br>";
print "    <table cellspacing=\"0\" border=\"1\">";
print "      <colgroup width=\"115\"></colgroup>";
print "      <colgroup span=\"10\" width=\"55\"></colgroup>";
print "      <tr>";
print "        <td align=\"center\"><b><br></b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg41</b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg42</b></td>";
print "        <td colspan=4 align=\"center\"><b>$msg43</b></td>";
print "        <td colspan=2 align=\"center\"><b>$msg44</b></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\" valign=top><b>$msg45</b></td>";
print "        <td align=\"center\">$config->{$section}{heater_on}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidifier_on}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td align=\"center\">$config->{$section}{vent_on}<br></td>";
print "        <td align=\"center\">m<br></td>";
print "        <td colspan=2 rowspan=4 align=\"center\"><br></td>";
print "        <td align=\"center\">$config->{$section}{light_on1}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg46</b></td>";
print "        <td align=\"center\">$config->{$section}{heater_off}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidifier_off}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td align=\"center\">$config->{$section}{vent_off}<br></td>";
print "        <td align=\"center\">m<br></td>";
print "        <td align=\"center\">$config->{$section}{light_off1}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg45</b></td>";
print "        <td colspan=4 rowspan=2 align=\"center\"><br></td>";
print "        <td colspan=2 rowspan=2 align=\"center\"><br></td>";
print "        <td align=\"center\">$config->{$section}{light_on2}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg46</b></td>";
print "        <td align=\"center\">$config->{$section}{light_off2}<br></td>";
print "        <td align=\"center\">h<br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg47</b></td>";
print "        <td align=\"center\">$config->{$section}{temperature_min}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{$section}{humidity_min}<br></td>";
print "        <td align=\"center\">%</td>";
print "        <td colspan=4 rowspan=2 align=\"center\"><br></td>";
print "        <td colspan=2 rowspan=28 align=\"center\"><br></td>";
print "      </tr>";
print "      <tr>";
print "        <td align=\"left\"><b>$msg48</b></td>";
print "        <td align=\"center\">$config->{mushroom}{temperature_max}<br></td>";
print "        <td align=\"center\">°C</td>";
print "        <td align=\"center\">$config->{mushroom}{humidity_max}<br></td>";
print "        <td align=\"center\">%</td>";
print "      </tr>";
print "      <tr>";
print "        <td rowspan=26 align=\"center\"><b>$msg49</b></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>$msg50</i></td>";
print "        <td colspan=2 align=\"center\"><i>< $config->{$section}{vent_lowtemp} °C</i></td>";
print "      </tr>";
my @i = (0..23);
for (@i)
{
  print "      <tr>";
  print "        <td align=\"center\">$_</td>";
  $v = "heater_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "humidifier_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "vent_disable_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "        <td align=\"center\">$_</td>";
  $v = "vent_disablelowtemp_" . sprintf ("%02d",$_);
  print "        <td align=\"center\">$config->{$section}{$v}<br></td>";
  print "      </tr>";
}
print "    </table>";
print "    <br>";
print "    $msg36";
print "    <br>";
# write footer
open FOOTER, $footerfile;
while (<FOOTER>)
{
  chomp;
  print "$_";
}
close FOOTER;
exit 0;