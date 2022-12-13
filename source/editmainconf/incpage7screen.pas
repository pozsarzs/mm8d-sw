{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.4 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage7screen.pas                                                       | }
{ | Show screen content of page #7                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page7screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/10: Directories');
  textcolor(white);
  gotoxy(4,3); writeln('HTML files for webserver:');
  gotoxy(4,4); writeln('Lock file:');
  gotoxy(4,5); writeln('Log files:');
  gotoxy(4,6); writeln('Translations:');
  gotoxy(4,7); writeln('Changing files:');
  gotoxy(4,8); writeln('Temporary files:');
  gotoxy(4,9); writeln('Data files:');
  gotoxy(MINPOSX[7,1],3); writeln(dir_htm);
  gotoxy(MINPOSX[7,1],4); writeln(dir_lck);
  gotoxy(MINPOSX[7,1],5); writeln(dir_log);
  gotoxy(MINPOSX[7,1],6); writeln(dir_msg);
  gotoxy(MINPOSX[7,1],7); writeln(dir_shr);
  gotoxy(MINPOSX[7,1],8); writeln(dir_tmp);
  gotoxy(MINPOSX[7,1],9); writeln(dir_var);
end;
