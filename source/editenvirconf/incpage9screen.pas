{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.2 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage9screen.pas                                                       | }
{ | Show screen content of page #9                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page9screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 9/9: Common parameters');
  textcolor(white);
  gotoxy(4,3); writeln('Relative unwanted gas concentrate:');
  gotoxy(45,3);
  if gasconmax>9 then gotoxy(45,3) else gotoxy(46,3); writeln(gasconmax,' %');
end;
