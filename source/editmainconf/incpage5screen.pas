{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage5screen.pas                                                       | }
{ | Show screen content of page #5                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page5screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 5/9: Directories');
  textcolor(white);
  gotoxy(4,3); writeln('HTML files for webserver:');
  gotoxy(4,4); writeln('lock file:');
  gotoxy(4,5); writeln('log files:');
  gotoxy(4,6); writeln('translations:');
  gotoxy(4,7); writeln('changing files:');
  gotoxy(4,8); writeln('temporary files:');
  gotoxy(4,9); writeln('data files:');
  gotoxy(MINPOSX[5,1],3); writeln(dir_htm);
  gotoxy(MINPOSX[5,1],4); writeln(dir_lck);
  gotoxy(MINPOSX[5,1],5); writeln(dir_log);
  gotoxy(MINPOSX[5,1],6); writeln(dir_msg);
  gotoxy(MINPOSX[5,1],7); writeln(dir_shr);
  gotoxy(MINPOSX[5,1],8); writeln(dir_tmp);
  gotoxy(MINPOSX[5,1],9); writeln(dir_var);
end;
