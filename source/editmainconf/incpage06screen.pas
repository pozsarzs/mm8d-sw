{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage06screen.pas                                                      | }
{ | Show screen content of page #6                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [directories]
  dir_htm=/var/www/html
  dir_lck=/var/local/lock
  dir_log=/var/local/log
  dir_msg=/usr/local/share/locale
  dir_shr=/usr/local/share/mm8d
  dir_tmp=/var/tmp
  dir_var=/var/local/lib/mm8d
}

// write options to screen
procedure page06screen;
const
  PAGE=6;
var
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Directories');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('webserver''s root:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('lock file:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('log files:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('translations:');
  gotoxy(4,MINPOSY[PAGE,block]+4); writeln('changing files:');
  gotoxy(4,MINPOSY[PAGE,block]+5); writeln('temporary files:');
  gotoxy(4,MINPOSY[PAGE,block]+6); writeln('data files:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(dir_htm);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); writeln(dir_lck);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); writeln(dir_log);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3); writeln(dir_msg);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+4); writeln(dir_shr);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+5); writeln(dir_tmp);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+6); writeln(dir_var);
end;
