{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.2 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage7screen.pas                                                       | }
{ | Show screen content of page #7                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page7screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/9: Growing mushroom - lighting');
  textcolor(white);
  gotoxy(4,3); writeln('Lamps switch-on time #1:');
  gotoxy(4,4); writeln('Lamps switch-off time #1:');
  gotoxy(4,5); writeln('Lamps switch-on time #2:');
  gotoxy(4,6); writeln('Lamps switch-off time #2:');
  gotoxy(45,3); if mlightson1<10 then write(' '); write(mlightson1,'.00');
  gotoxy(45,4); if mlightsoff1<10 then write(' '); write(mlightsoff1,'.00');
  gotoxy(45,5); if mlightson2<10 then write(' '); write(mlightson2,'.00');
  gotoxy(45,6); if mlightsoff2<10 then write(' '); write(mlightsoff2,'.00');
end;
