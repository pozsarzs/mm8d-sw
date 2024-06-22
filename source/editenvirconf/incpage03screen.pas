{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage03screen.pas                                                      | }
{ | Show screen content of page #3                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [hyphae]
  light_on1=0
  light_off1=0
  light_on2=0
  light_off2=0
}

// write options to screen
procedure page03screen;
var
  block: byte;
const
  PAGE=3;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing hyphae - lighting');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('lamps switch-on time #1:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('lamps switch-off time #1:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('lamps switch-on time #2:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('lamps switch-off time #2:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]); if hlightson1<10 then write(' '); write(hlightson1,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+1); if hlightsoff1<10 then write(' '); write(hlightsoff1,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+2); if hlightson2<10 then write(' '); write(hlightson2,'.00');
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+3); if hlightsoff2<10 then write(' '); write(hlightsoff2,'.00');
end;
