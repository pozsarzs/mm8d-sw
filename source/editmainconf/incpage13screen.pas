{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage13screen.pas                                                      | }
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

  [heater]
  ith_ch?=0
}

// write options to screen
procedure page13screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 13/13: Heater timer control only');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[3,1],b+2);
    writeln(ith_ch[b]);
  end;
end;
