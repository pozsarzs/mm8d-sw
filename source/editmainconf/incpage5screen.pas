{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
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

procedure page5screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 5/10: I/O ports');
  textcolor(white);
  for b:=0 to 7 do
  begin
    gotoxy(4,b+2+1); write('IN'+inttostr(b)+':   GPIO');
    gotoxy(4,b+2+9+1); write('OUT'+inttostr(b)+':  GPIO');
  end;
  gotoxy(4,9+2+9+1); write('Address of LPT port:');
  gotoxy(4,10+2+9+1); write('  0: 0x378');
  gotoxy(4,11+2+9+1); write('  1: 0x278');
  gotoxy(4,12+2+9+1); write('  2: 0x3bc');
  for b:=0 to 7 do
  begin
    gotoxy(MINPOSX[5,1],b+2+1); writeln(prt_in[b]);
    gotoxy(MINPOSX[5,2],b+2+9+1); writeln(prt_out[b]);
  end;
  gotoxy(MINPOSX[5,3],9+2+9+1); writeln(lpt_prt);
end;
