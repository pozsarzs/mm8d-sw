{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage10screen.pas                                                      | }
{ | Show screen content of page #10                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page10screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 10/10: Logging');
  textcolor(white);
  gotoxy(4,3); writeln('Storing time of log records in days:');
  gotoxy(4,4); writeln('Enable debug log (0: disable):');
  gotoxy(4,5); writeln('Number of log lines on web interface:');
  gotoxy(MINPOSX[10,1],3); writeln(day_log);
  gotoxy(MINPOSX[10,1],4); writeln(dbg_log);
  gotoxy(MINPOSX[10,1],5); writeln(web_lines);
end;
