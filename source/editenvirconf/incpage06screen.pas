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

  [mushroom]
  humidity_min=85
  humidifier_on=89
  humidifier_off=90
  humidity_max=95
}

// write options to screen
procedure page06screen;
var
  b: byte;
const
  PAGE=6;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - humidifying');
  textcolor(white);
  // #1
  gotoxy(4,3); writeln('Minimal relative humidity:');
  gotoxy(4,4); writeln('Lower warning level of humidity:');
  gotoxy(4,5); writeln('Higher warning level of humidity:');
  gotoxy(4,6); writeln('Maximal relative humidity:');
  if mhummin>9 then gotoxy(MINPOSX[PAGE,1]-1,3) else gotoxy(MINPOSX[PAGE,1],3); writeln(mhummin,' %');
  if mhumon>9 then gotoxy(MINPOSX[PAGE,1]-1,4) else gotoxy(MINPOSX[PAGE,1],4); writeln(mhumon,' %');
  if mhumoff>9 then gotoxy(MINPOSX[PAGE,1]-1,5) else gotoxy(MINPOSX[PAGE,1],5); writeln(mhumoff,' %');
  if mhummax>9 then gotoxy(MINPOSX[PAGE,1]-1,6) else gotoxy(MINPOSX[PAGE,1],6); writeln(mhummax,' %');
end;
