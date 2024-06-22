{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage08screen.pas                                                      | }
{ | Show screen content of page #8                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [localio]
  gpio_i1=2
  gpio_i2=3
  gpio_i3=4
  gpio_i4=5
  gpio_i5=6
  gpio_lo1=16
  gpio_lo2=17
  gpio_lo3=18
  gpio_lo4=19
  gpio_ro1=20
  gpio_ro2=21
  gpio_ro3=22
  gpio_ro4=23
  gpio_ro5=24
  gpio_ro6=25
  gpio_ro7=26
  gpio_ro8=27
}

// write options to screen
procedure page08screen;
var
  b: byte;
const
  PAGE=8;
var
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': I/O ports');
  textcolor(lightcyan);
  block:=1;
  for b:=1 to 5 do
  begin
    textcolor(lightcyan);
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('I'+inttostr(b)+':   ');
    textcolor(white);
    write('GPIO');
  end;
  block:=2;
  for b:=1 to 4 do
  begin
    textcolor(lightcyan);
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('LO'+inttostr(b)+':  ');
    textcolor(white);
    write('GPIO');
  end;
  block:=3;
  for b:=1 to 8 do
  begin
    textcolor(lightcyan);
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('RO'+inttostr(b)+':  ');
    textcolor(white);
    write('GPIO');
  end;
  textcolor(white);
  block:=1;
  for b:=1 to 5 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); writeln(gpio_i[b]);
  end;
  block:=2;
  for b:=1 to 4 do
  begin  
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); writeln(gpio_lo[b]);
  end;
  block:=3;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); writeln(gpio_ro[b]);
  end;
end;
