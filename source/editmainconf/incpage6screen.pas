{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage6screen.pas                                                       | }
{ | Show screen content of page #6                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page6screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 6/10: URL of IP cameras');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  gotoxy(4,12); write('Show camera snapshots:');
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[6,1],b+2);
    writeln(cam_ch[b]);
  end;
  gotoxy(MINPOSX[6,2],12); writeln(lpt_prt);
end;
