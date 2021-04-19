{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage4screen.pas                                                       | }
{ | Show screen content of page #4                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page4screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 4/10: IP address of controllers');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2); write('MM6D on channel #'+inttostr(b)+':');
    gotoxy(4,b+2+9); write('MM7D on channel #'+inttostr(b)+':');
  end;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[4,1],b+2); writeln(adr_mm6dch[b]);
    gotoxy(MINPOSX[4,2],b+2+9); writeln(adr_mm7dch[b]);
  end;
end;
