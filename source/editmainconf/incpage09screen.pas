{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage09screen.pas                                                      | }
{ | Show screen content of page #9                                           | }
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
  pro_mm6dch1=http

  [MM7D]
  pro_mm7dch1=http

  [MM10D]
  pro_mmd10=http
}

// write options to screen
procedure page09screen;
var
  b: byte;

begin
  header(PRGNAME+' '+VERSION+' * Page 9/12: Communication protocol of controllers');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2); write('MM6D on channel #'+inttostr(b)+':');
    gotoxy(4,b+2+9); write('MM7D on channel #'+inttostr(b)+':');
  end;
  gotoxy(4,21); write('MM10D:');
  for b:=1 to 8 do
  begin
    if (pro_mm6dch[b]<>PROTOCOL[1]) and (pro_mm6dch[b]<>PROTOCOL[2]) then pro_mm6dch[b]:=PROTOCOL[1];
    gotoxy(MINPOSX[9,1],b+2); writeln(pro_mm6dch[b]);
    if (pro_mm7dch[b]<>PROTOCOL[1]) and (pro_mm7dch[b]<>PROTOCOL[2]) then pro_mm7dch[b]:=PROTOCOL[1];
    gotoxy(MINPOSX[9,2],b+2+9); writeln(pro_mm7dch[b]);
  end;
  if (pro_mm10d<>PROTOCOL[1]) and (pro_mm10d<>PROTOCOL[2]) then pro_mm10d:=PROTOCOL[1];
  gotoxy(MINPOSX[9,3],21); writeln(pro_mm10d);
end;
