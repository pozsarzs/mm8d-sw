{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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

  [GPIOport]
  prt_i1=12
  prt_i2=16
  prt_i3=20
  prt_i4=21
  prt_ro1=18
  prt_ro2=23
  prt_ro3=24
  prt_ro4=25
  prt_lo1=2
  prt_lo2=3
  prt_lo3=4
  prt_lo4=17

  [LPTport]
  prt_lpt=0

  [COMport]
  ena_console=1
  prt_com=/dev/ttyS0
  com_speed=9600
  com_verbose=2
}

// write options to screen
procedure page08screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 8/' + inttostr(LASTPAGE) + ': I/O ports');
  textcolor(white);
  for b:=1 to 4 do
  begin
    gotoxy(4,b+2); write('I'+inttostr(b)+':   GPIO');
    gotoxy(4,b+2+5); write('RO'+inttostr(b)+':  GPIO');
    gotoxy(4,b+2+10); write('LO'+inttostr(b)+':  GPIO');
  end;
  gotoxy(4,18); write('Address of LPT port:');
  gotoxy(4,19); write('  1: 0x378');
  gotoxy(4,20); write('  2: 0x278');
  gotoxy(4,21); write('  3: 0x3bc');
  gotoxy(4,23); write('Enable serial console:');
  gotoxy(4,24); write('COM port:');
  gotoxy(4,25); write('Port speed:');
  gotoxy(4,26); write('Verbose log screen:');
  for b:=1 to 4 do
  begin
    gotoxy(MINPOSX[8,1],b+2); writeln(prt_i[b]);
    gotoxy(MINPOSX[8,2],b+2+5); writeln(prt_ro[b]);
    gotoxy(MINPOSX[8,3],b+2+10); writeln(prt_lo[b]);
  end;
  gotoxy(MINPOSX[8,4],18); writeln(prt_lpt);
  gotoxy(MINPOSX[8,5],23); writeln(ena_console);
  gotoxy(MINPOSX[8,5],24); writeln(prt_com);
  gotoxy(MINPOSX[8,5],25); writeln(com_speed);
  gotoxy(MINPOSX[8,5],26); writeln(com_verbose);
end;
