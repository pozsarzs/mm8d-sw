#!/usr/bin/perl
# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | getcameras.cgi                                                             |
# | Get snapshots of the security cameras in HTML format                       |
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
my $getsnapshotprog;
my $dark="<font color=\"gray\">&#9679;</font>";
my $footerfile;
my $green="<font color=\"green\">&#9679;</font>";
my $headerfile;
my $line;
my $red="<font color=\"red\">&#9679;</font>";
my $row;
my $yellow="<font color=\"yellow\">&#9679;</font>";

if (USRLOCALDIR eq 1)
{
  $conffile = "/usr/local/etc/mm8d/mm8d.ini";
  $getsnapshotprog = "/usr/local/bin/mm8d-getsnapshots-seccam";
} else
{
  $conffile = "/etc/mm8d/mm8d.ini";
  $getsnapshotprog = "/usr/bin/mm8d-getsnapshots-seccam";
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
my $dir_msg;
my $dir_shr;
my $dir_var;
my $lang;
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
      case "dir_msg" { $dir_msg = $columns[1]; }
      case "dir_shr" { $dir_shr = $columns[1]; }
      case "dir_var" { $dir_var = $columns[1]; }
      case "lng" { $lang = $columns[1]; }
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
my $msg70 = "Security cameras";
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
    case "msg70" { $msg70 = $columns[1]; }
  }
}
close MSG;

# set filenames
$footerfile = $dir_shr . "/footer_" . $lang . ".html";
$headerfile = $dir_shr . "/header_" . $lang . ".html";
# get snapshots
system("$getsnapshotprog");
# create output
print "Content-type:text/html\r\n\r\n";
writeheader();
print "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"6\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <td colspan=\"2\" class=\"header\" align=\"center\">";
print "            <b class=\"title0\">$msg70</b>";
print "          </td>";
print "        </tr>";
print "      </tbody>";
print "    </table>";
print "    <br>";
print "    <table border=\"1\" cellpadding=\"20\" cellspacing=\"0\" width=\"100%\">";
print "      <tbody>";
print "        <tr>";
print "          <td width=\"50%\"><img src=\"/snapshots/camera-1.jpg\" width=\"100%\"></td>";
print "        </tr>";
print "        <tr>";
print "          <td width=\"50%\"><img src=\"/snapshots/camera-2.jpg\" width=\"100%\"></td>";
print "        </tr>";
print "        <tr>";
print "          <td width=\"50%\"><img src=\"/snapshots/camera-3.jpg\" width=\"100%\"></td>";
print "        </tr>";
print "        <tr>";
print "          <td width=\"50%\"><img src=\"/snapshots/camera-4.jpg\" width=\"100%\"></td>";
print "        </tr>";
print "        <tr>";
print "          <td width=\"50%\"><img src=\"/snapshots/camera-5.jpg\" width=\"100%\"></td>";
print "        </tr>";
print "      </tbody>";
print "    </table>";
print "    <br>";
writefooter();
exit 0;
