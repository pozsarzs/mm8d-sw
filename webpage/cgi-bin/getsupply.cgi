#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | getsupply.cgi                                                              |
# | Get power supply data in HTML format                                       |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit
#   1: cannot open configuration file
#   5: cannot open log file
#  10: bad channel value

use constant USRLOCALDIR => 1;

use lib 'cgi-bin';
use Switch;
use Scalar::Util qw(looks_like_number);
use strict;
use warnings;

my $conffile;
my $creatediagprog;
my $dark="<font color=\"gray\">&#9679;</font>";
my $footerfile;
my $green="<font color=\"green\">&#9679;</font>";
my $headerfile;
my $line;
my $lockfile;
my $logfile;
my $red="<font color=\"red\">&#9679;</font>";
my $row;
my $yellow="<font color=\"yellow\">&#9679;</font>";

if (USRLOCALDIR eq 1)
{
  $conffile = "/usr/local/etc/mm8d/mm8d.ini";
  $creatediagprog = "/usr/local/bin/mm8d-creatediagrams";
} else
{
  $conffile = "/etc/mm8d/mm8d.ini";
  $creatediagprog = "/usr/bin/mm8d-creatediagrams";
}

# write header of webpage
sub writeheader()
{
  open HEADER, $headerfile;
  while (<HEADER>)
  {
    chomp;
    print "$_";
  }
  close HEADER;
}

# write footer of webpage
sub writefooter()
{
  open FOOTER, $footerfile;
  while (<FOOTER>)
  {
    chomp;
    print "$_";
  }
  close FOOTER;
}

# write table on webpage
sub writetable()
{
  my(@columns)= split(",");
  my($colnum)=$#columns;
  $row = "";
  foreach $colnum (@columns)
  {
    $row = $row . $colnum;
  }
  my(@datarow) = split("\"\"",$row);
  my($datarownum) = $#datarow;
  print "        <tr align=\"center\">";
  my $shortdate = substr($columns[0],5,5);
  print "          <td>$shortdate</td>";
  print "          <td>$columns[1]</td>";
  print "          <td>$columns[2]</td>";
  print "          <td>$columns[3]</td>";
  print "          <td>$columns[4]</td>";
  print "          <td>$columns[5]</td>";
  print "          <td>$columns[6]</td>";
  print "          <td>$columns[7]</td>";
}

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

# load configuration
my $dir_htm;
my $dir_lck;
my $dir_log;
my $dir_msg;
my $dir_shr;
my $dir_var;
my $lang;
my $web_lines;
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
      case "dir_htm" { $dir_htm = $columns[1]; }
      case "dir_lck" { $dir_lck = $columns[1]; }
      case "dir_log" { $dir_log = $columns[1]; }
      case "dir_msg" { $dir_msg = $columns[1]; }
      case "dir_shr" { $dir_shr = $columns[1]; }
      case "dir_var" { $dir_var = $columns[1]; }
      case "lng" { $lang = $columns[1]; }
      case "web_lines" { $web_lines = $columns[1]; }
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
my $msg10 = "Names";
my $msg24 = "date";
my $msg25 = "time";
my $msg26 = "Latest status";
my $msg27 = "Refresh";
my $msg29 = "Log";
my $msg30 = "Log in with SSH and use <i>mm8d-viewlog</i> to see full log.";
my $msg31 = "Start page";
my $msg71 = "Power supply";
my $msg72 = "Effectice mains voltage [V]";
my $msg73 = "Effectice mains current [A]";
my $msg74 = "Actice power [W]";
my $msg75 = "Reactive power [VAr]";
my $msg76 = "Apparent power [VA]";
my $msg77 = "cos &phi;";
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
    case "msg10" { $msg10 = $columns[1]; }
    case "msg24" { $msg24 = $columns[1]; }
    case "msg25" { $msg25 = $columns[1]; }
    case "msg26" { $msg26 = $columns[1]; }
    case "msg27" { $msg27 = $columns[1]; }
    case "msg29" { $msg29 = $columns[1]; }
    case "msg30" { $msg30 = $columns[1]; }
    case "msg31" { $msg31 = $columns[1]; }
    case "msg71" { $msg71 = $columns[1]; }
    case "msg72" { $msg72 = $columns[1]; }
    case "msg73" { $msg73 = $columns[1]; }
    case "msg74" { $msg74 = $columns[1]; }
    case "msg75" { $msg75 = $columns[1]; }
    case "msg76" { $msg76 = $columns[1]; }
    case "msg77" { $msg77 = $columns[1]; }
  }
}
close MSG;

# set filenames
$footerfile = $dir_shr . "/footer_" . $lang . ".html";
$headerfile = $dir_shr . "/header_" . $lang . ".html";
$lockfile = $dir_lck . "/mm8d.lock";
$logfile = $dir_log . "/mm8d-supply.log";
# create diagram pictures
system("$creatediagprog -1");
# create output
print "Content-type:text/html\r\n\r\n";
writeheader();
while (-e $lockfile)
{
  sleep 1;
}
print "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"6\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <td colspan=\"2\" class=\"header\" align=\"center\">";
print "            <b class=\"title0\">$msg71</b>";
print "          </td>";
print "        </tr>";
print "      </tbody>";
print "    </table>";
print "    <br>";
# names
print "    <b class=\"title1\">$msg10</b><br>";
print "    <br>";
print "    <table border=\"0\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">";
print "      <tbody>";
print "        <tr><td align=\"right\"><b>1:</b></td><td>$msg72</td></tr>";
print "        <tr><td align=\"right\"><b>2:</b></td><td>$msg73</td></tr>";
print "        <tr><td align=\"right\"><b>3:</b></td><td>$msg74</td></tr>";
print "        <tr><td align=\"right\"><b>4:</b></td><td>$msg75</td></tr>";
print "        <tr><td align=\"right\"><b>5:</b></td><td>$msg76</td></tr>";
print "        <tr><td align=\"right\"><b>6:</b></td><td>$msg77</td></tr>";
print "      </tbody>";
print "    </table>";
print "    <hr>";
print "    <br>";
# latest status
print "    <b class=\"title1\">$msg26</b><br>";
print "    <br>";
print "    <table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <th>$msg24</th><th>$msg25</th>";
print "          <th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th>";
print "        </tr>";
if (-e $logfile)
{
  open DATA, "< $logfile";
  while (<DATA>)
  {
    chop;
    writetable();
    last;
  }
  close DATA;
} else
{
  print "      </tbody>";
  print "    </table>";
  print "    <br>";
  print "    ERROR #5: Cannot open ",$logfile," log file!";
  print "    <br>";
  print "    <br>";
  print "    <center>";
  print "      <a href=/index.html><input value=\"$msg31\" type=\"submit\"></a>";
  print "    </center>";
  print "    <br>";
  writefooter();
  exit 5;
}
print "      </tbody>";
print "    </table>";
print "    <br>";
print "    <center>";
print "      <a href=/index.html><input value=\"$msg31\" type=\"submit\"></a>";
print "      <a href=/cgi-bin/getsupply.cgi><input value=\"$msg27\" type=\"submit\"></a>";
print "    </center>";
print "    <br>";
print "    <hr>";
print "    <br>";
# log
print "    <b class=\"title1\">$msg29</b><br>";
print "    <br>";
print "    <table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">";
print "      <tbody>";
print "        <tr><td><img src=\"/diagrams/voltage.png\" width=\"100%\"></td></tr>";
print "        <tr><td><img src=\"/diagrams/current.png\" width=\"100%\"></td></tr>";
print "        <tr><td><img src=\"/diagrams/power.png\" width=\"100%\"></td></tr>";
print "      </tbody>";
print "    </table>";
print "    <br>";
print "    <table border=\"1\" cellpadding=\"3\" cellspacing=\"0\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <th>$msg24</th><th>$msg25</th>";
print "          <th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th>";
print "        </tr>";
$line = 0;
if (-e $logfile)
{
  open DATA, "< $logfile";
  while (<DATA>)
  {
    chop;
    writetable();
    $line = $line + 1;
    if ($line eq $web_lines) { last };
  }
  close DATA;
} else
{
  print "      </tbody>";
  print "    </table>";
  print "    <br>";
  print "ERROR #5: Cannot open ",$logfile," log file!";
  print "    <br>";
  writefooter();
  exit 5;
}
print "      </tbody>";
print "    </table>";
print "    <br>";
print "    <small>$msg30</small>";
print "    <br>";
writefooter();
exit 0;
