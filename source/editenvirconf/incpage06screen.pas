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
  block: byte;
const
  PAGE=6;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - humidifying');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('minimal relative humidity:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('lower warning level:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('higher warning level:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('maximal relative humidity:');
  textcolor(white);
  if mhummin>9 then gotoxy(MINPOSX[PAGE,1]-1,MINPOSY[PAGE,block]) else gotoxy(MINPOSX[PAGE,1],MINPOSY[PAGE,block]); writeln(mhummin,' %');
  if mhumon>9 then gotoxy(MINPOSX[PAGE,1]-1,MINPOSY[PAGE,block]+1) else gotoxy(MINPOSX[PAGE,1],MINPOSY[PAGE,block]+1); writeln(mhumon,' %');
  if mhumoff>9 then gotoxy(MINPOSX[PAGE,1]-1,MINPOSY[PAGE,block]+2) else gotoxy(MINPOSX[PAGE,1],MINPOSY[PAGE,block]+2); writeln(mhumoff,' %');
  if mhummax>9 then gotoxy(MINPOSX[PAGE,1]-1,MINPOSY[PAGE,block]+3) else gotoxy(MINPOSX[PAGE,1],MINPOSY[PAGE,block]+3); writeln(mhummax,' %');
end;
