{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage08screen.pas                                                      | }
{ | Show screen content of page #8                                           | }
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
  light_on1=0
  light_off1=0
  light_on2=0
  light_off2=0
}

// write options to screen
procedure page08screen;
var
  block: byte;
const
  PAGE=8;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - lighting');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('lamps switch-on time #1:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('lamps switch-off time #1:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('lamps switch-on time #2:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('lamps switch-off time #2:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]); if mlightson1<10 then write(' '); write(mlightson1,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+1); if mlightsoff1<10 then write(' '); write(mlightsoff1,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+2); if mlightson2<10 then write(' '); write(mlightson2,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+3); if mlightsoff2<10 then write(' '); write(mlightsoff2,'.00');
end;
