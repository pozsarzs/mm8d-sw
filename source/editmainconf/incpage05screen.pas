{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
  day_log=7
  dbg_log=0
  web_lines=30
}

// write options to screen
procedure page05screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 5/12: Logging');
  textcolor(white);
  gotoxy(4,3); writeln('Storing time of log records in days:');
  gotoxy(4,4); writeln('Enable debug log (0: disable):');
  gotoxy(4,5); writeln('Number of log lines on web interface:');
  gotoxy(MINPOSX[5,1],3); writeln(day_log);
  gotoxy(MINPOSX[5,1],4); writeln(dbg_log);
  gotoxy(MINPOSX[5,1],5); writeln(web_lines);
end;
