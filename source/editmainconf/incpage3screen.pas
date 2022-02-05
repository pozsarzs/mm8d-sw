{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage3screen.pas                                                       | }
{ | Show screen content of page #3                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page3screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 3/10: Name of channels');
  textcolor(white);
  for b:=0 to 8 do
  begin
    gotoxy(4,b+1+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=0 to 8 do
  begin
    gotoxy(MINPOSX[3,1],b+1+2);
    writeln(nam_ch[b]);
  end;
end;
