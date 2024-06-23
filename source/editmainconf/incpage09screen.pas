{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage09screen.pas                                                      | }
{ | Show screen content of page #09                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  lpt_address=0x378
  lpt_i?_bit=0
  lpt_i?_negation=0
  lpt_lo?_bit=0
  lpt_lo?_negation=0
  lpt_ro?_bit=0
  lpt_ro?_negation=0
}

// write options to screen
procedure page09screen;
const
  PAGE=9;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Paralel port');
  textcolor(lightcyan);
  block:=1;
  gotoxy(4,MINPOSY[PAGE,block]-1); write('number of the bit:');
  for b:=1 to 17 do
  begin
    gotoxy(5,MINPOSY[PAGE,block]+b-1);
    if b<=5 then write('input i'+inttostr(b)+':');
    if (b>5) and (b<=9) then write('LED output lo'+inttostr(b-5)+':');
    if (b>9) then write('relay output ro'+inttostr(b-9)+':');
  end;
  block:=2;
  gotoxy(45,MINPOSY[PAGE,block]-1); write('negation:');
  for b:=1 to 17 do
  begin
    gotoxy(46,MINPOSY[PAGE,block]+b-1);
    if b<=5 then write('input i'+inttostr(b)+':');
    if (b>5) and (b<=9) then write('LED output lo'+inttostr(b-5)+':');
    if (b>9) then write('relay output ro'+inttostr(b-9)+':');
  end;
  block:=3;
  gotoxy(4,MINPOSY[PAGE,block]); write('base address:');
  textcolor(white);
  block:=1;
  for b:=1 to 17 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    if b<=5 then write(lpt_i_bit[b]);
    if (b>5) and (b<=9) then write(lpt_lo_bit[b-5]);
    if (b>9) then write(lpt_ro_bit[b-9]);
  end;
  block:=2;
  for b:=1 to 17 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    if b<=5 then write(lpt_i_negation[b]);
    if (b>5) and (b<=9) then write(lpt_lo_negation[b-5]);
    if (b>9) then write(lpt_ro_negation[b-9]);
  end;
  block:=3;
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]);
  write('0x'+inttohex(lpt_address,3));
end;
