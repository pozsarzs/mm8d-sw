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
  ena_mm10d=0
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
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[9,1],b+2); writeln(adr_mm6dch[b]);
    gotoxy(MINPOSX[9,2],b+2+9); writeln(adr_mm7dch[b]);
  end;
end;
