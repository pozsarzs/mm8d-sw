{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage01screen.pas                                                      | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [common]
  temp_min=10
  temp_max=35
}

// write options to screen
procedure page01screen;
var
  block: byte;
const
  PAGE=1;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Common parameters');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('minimal outdoor temperature:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('maximal outdoor temperature:');
  textcolor(white);
  if tempmin>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]) else gotoxy(MINPOSX[1,1],MINPOSY[PAGE,block]); writeln(tempmin,' °C');
  if tempmax>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+1) else gotoxy(MINPOSX[1,1],MINPOSY[PAGE,block]+1); writeln(tempmax,' °C');
end;
