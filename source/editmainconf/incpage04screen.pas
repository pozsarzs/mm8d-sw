{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
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
begin
  header(PRGNAME+' '+VERSION+' * Page 4/12: Web page language');
  textcolor(white);
  gotoxy(4,3); writeln('English');
  gotoxy(4,4); writeln('Hungarian');
  b:=0;
  for b:=3 to 4 do
    if lng=CODE[b] then break;
  if b=0 then b:=5;
  gotoxy(MINPOSX[4,1],b); writeln('<<');
end;
