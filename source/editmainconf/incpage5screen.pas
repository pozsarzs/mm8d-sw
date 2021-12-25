{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.2 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage5screen.pas                                                       | }
{ | Show screen content of page #5                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page5screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 5/10: I/O ports');
  textcolor(white);
  for b:=1 to 4 do
  begin
    gotoxy(4,b+2); write('I'+inttostr(b)+':   GPIO');
    gotoxy(4,b+2+5); write('RO'+inttostr(b)+':  GPIO');
    gotoxy(4,b+2+10); write('LO'+inttostr(b)+':  GPIO');
  end;
  gotoxy(4,18); write('Address of LPT port:');
  gotoxy(4,19); write('  0: 0x378');
  gotoxy(4,20); write('  1: 0x278');
  gotoxy(4,21); write('  2: 0x3bc');
  for b:=1 to 4 do
  begin
    gotoxy(MINPOSX[5,1],b+2); writeln(prt_i[b]);
    gotoxy(MINPOSX[5,2],b+2+5); writeln(prt_ro[b]);
    gotoxy(MINPOSX[5,3],b+2+10); writeln(prt_lo[b]);
  end;
  gotoxy(MINPOSX[5,4],18); writeln(lpt_prt);
end;
