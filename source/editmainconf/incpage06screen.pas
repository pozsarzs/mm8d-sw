{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
begin
  header(PRGNAME+' '+VERSION+' * Page 6/12: Directories');
  textcolor(white);
  gotoxy(4,3); writeln('HTML files for webserver:');
  gotoxy(4,4); writeln('Lock file:');
  gotoxy(4,5); writeln('Log files:');
  gotoxy(4,6); writeln('Translations:');
  gotoxy(4,7); writeln('Changing files:');
  gotoxy(4,8); writeln('Temporary files:');
  gotoxy(4,9); writeln('Data files:');
  gotoxy(MINPOSX[6,1],3); writeln(dir_htm);
  gotoxy(MINPOSX[6,1],4); writeln(dir_lck);
  gotoxy(MINPOSX[6,1],5); writeln(dir_log);
  gotoxy(MINPOSX[6,1],6); writeln(dir_msg);
  gotoxy(MINPOSX[6,1],7); writeln(dir_shr);
  gotoxy(MINPOSX[6,1],8); writeln(dir_tmp);
  gotoxy(MINPOSX[6,1],9); writeln(dir_var);
end;
