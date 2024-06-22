{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage10screen.pas                                                      | }
{ | Show screen content of page #10                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [MM6D]
  uid_mm6dch?=11

  [MM7D]
  uid_mm7dch?=21

  [MM10D]
  uid_mm10d=30

  [MM11D]
  uid_mm11d=31
}

// write options to screen
procedure page10screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 10/' + inttostr(LASTPAGE) + ': ModBUS unitID of controllers');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2); write('MM6D on channel #'+inttostr(b)+':');
    gotoxy(4,b+2+9); write('MM7D on channel #'+inttostr(b)+':');
  end;
  gotoxy(4,21); write('MM10D:');
  gotoxy(4,22); write('MM11D:');
  {
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[10,1],b+2); writeln(uid_mm6dch[b]);
    gotoxy(MINPOSX[10,2],b+2+9); writeln(uid_mm7dch[b]);
  end;
  gotoxy(MINPOSX[10,3],21); writeln(uid_mm10d);
  gotoxy(MINPOSX[10,3],22); writeln(uid_mm11d);
  }
end;
