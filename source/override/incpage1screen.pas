{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page1screen(dir: string);
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Override output status');
  textcolor(white);
  if dir[length(dir)] = '0' then
  begin  
    gotoxy(4,3); writeln('Irrigator tube #1:');
    gotoxy(4,4); writeln('Irrigator tube #2:');
    gotoxy(4,5); writeln('Irrigator tube #3:');
  end else
  begin
    gotoxy(4,3); writeln('Output #1 - lamp:');
    gotoxy(4,4); writeln('Output #2 - ventilator:');
    gotoxy(4,5); writeln('Output #3 - heater:');
  end;
  for b:=1 to 3 do
  begin
    gotoxy(30,2+b); writeln(outputs[b]);
  end;
end;
