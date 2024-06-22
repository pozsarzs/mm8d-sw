{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage05screen.pas                                                      | }
{ | Show screen content of page #5                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [log]
  log_day=7
  log_debug=0
  log_weblines=30
}

// write options to screen
procedure page05screen;
const
  PAGE=5;
var
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Logging');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('storing time of log records in days:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('enable debug log (0: disable):');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('number of log lines on web interface:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(log_day);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); writeln(log_debug);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); writeln(log_weblines);
end;
