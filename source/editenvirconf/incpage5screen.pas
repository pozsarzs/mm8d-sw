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
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 5/9: Growing mushroom - humidifying');
  textcolor(white);
  gotoxy(4,3); writeln('Minimal relative humidity:');
  gotoxy(4,4); writeln('Lower warning level of humidity:');
  gotoxy(4,5); writeln('Higher warning level of humidity:');
  gotoxy(4,6); writeln('Maximal relative humidity:');
  if mhummin>9 then gotoxy(45,3) else gotoxy(46,3); writeln(mhummin,' %');
  if mhumon>9 then gotoxy(45,4) else gotoxy(46,4); writeln(mhumon,' %');
  if mhumoff>9 then gotoxy(45,5) else gotoxy(46,5); writeln(mhumoff,' %');
  if mhummax>9 then gotoxy(45,6) else gotoxy(46,6); writeln(mhummax,' %');
end;
