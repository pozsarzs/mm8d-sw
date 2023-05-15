{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
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
  light_on1=6
  light_off1=12
  light_on2=16
  light_off2=22
}

// write options to screen
procedure page08screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 8/11: Growing mushroom - lighting');
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
