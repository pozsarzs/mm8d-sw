{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage03screen.pas                                                      | }
{ | Show screen content of page #3                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [enable]
  ena_ch?=1

  [MM10D]
  ena_mm10d=0
}

// write options to screen
procedure page03screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 3/12: Enable/disable channels');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  gotoxy(4,12); write('MM10D:');
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[3,1],b+2);
    writeln(ena_ch[b]);
  end;
  gotoxy(MINPOSX[3,1],12); write(ena_mm10d);
end;
