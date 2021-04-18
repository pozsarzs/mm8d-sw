{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
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

procedure page7screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/9: Language of webpages');
  textcolor(white);
  gotoxy(4,3); writeln('English');
  gotoxy(4,4); writeln('Hungarian');
  b:=0;
  for b:=3 to 4 do
    if lng=CODE[b] then break;
  if b=0 then b:=5;
  gotoxy(MINPOSX[7,1],b); writeln('<<');
end;
