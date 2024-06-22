{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage04screen.pas                                                      | }
{ | Show screen content of page #4                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [language]
  lng=en
}

// write options to screen
procedure page04screen;
var
  b: byte;
  block: byte;
const
  PAGE=4;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Web page language');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('English');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('Hungarian');
  b:=0;
  for b:=MINPOSY[PAGE,block] to 4 do
    if lng=CODE[b] then break;
  if b=0 then b:=5;
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],b); writeln('<<');
end;
