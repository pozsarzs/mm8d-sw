{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page1screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 1/9: User data');
  textcolor(white);
  gotoxy(4,3); write('User''s name:');
  gotoxy(4,4); write('User''s ID:');
  gotoxy(4,5); write('Address - city:');
  gotoxy(4,6); write('Address:');
  gotoxy(4,7); write('Name of growing houses:');
  gotoxy(MINPOSX[1,1],3); write(usr_nam);
  gotoxy(MINPOSX[1,1],4); write(usr_uid);
  for b:=1 to 3 do
  begin
    gotoxy(MINPOSX[1,1],b+4); writeln(usr_dt[b]);
  end;
end;