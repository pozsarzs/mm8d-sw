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
  b: byte;
  x: byte;
const
  PAGE=1;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Common parameters');
  textcolor(white);
  gotoxy(4,3); writeln('Minimal temperature (below this, irrigation is missed):');
  gotoxy(4,4); writeln('Maximal temperature (above this, irrigation is missed):');
  x:=75;
  if tempmin>9 then gotoxy(x,3) else gotoxy(x+1,3); writeln(tempmin,' °C');
  if tempmax>9 then gotoxy(x,4) else gotoxy(x+1,4); writeln(tempmax,' °C');
end;
