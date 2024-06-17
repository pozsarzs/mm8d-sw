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
const
  PAGE=3;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing hyphae - lighting');
  textcolor(white);
  gotoxy(4,3); writeln('Lamps switch-on time #1:');
  gotoxy(4,4); writeln('Lamps switch-off time #1:');
  gotoxy(4,5); writeln('Lamps switch-on time #2:');
  gotoxy(4,6); writeln('Lamps switch-off time #2:');
  gotoxy(MINPOSX[PAGE,1]-1,3); if hlightson1<10 then write(' '); write(hlightson1,'.00');
  gotoxy(MINPOSX[PAGE,1]-1,4); if hlightsoff1<10 then write(' '); write(hlightsoff1,'.00');
  gotoxy(MINPOSX[PAGE,1]-1,5); if hlightson2<10 then write(' '); write(hlightson2,'.00');
  gotoxy(MINPOSX[PAGE,1]-1,6); if hlightsoff2<10 then write(' '); write(hlightsoff2,'.00');
end;
