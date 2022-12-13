{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.4 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page1screen;
var
  b: byte;
  x: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 1/2: Common parameters');
  textcolor(white);
  gotoxy(4,3); writeln('Minimal temperature (below this, irrigation is missed):');
  gotoxy(4,4); writeln('Maximal temperature (above this, irrigation is missed):');
  x:=75;
  if tempmin>9 then gotoxy(x,3) else gotoxy(x+1,3); writeln(tempmin,' °C');
  if tempmax>9 then gotoxy(x,4) else gotoxy(x+1,4); writeln(tempmax,' °C');
end;
