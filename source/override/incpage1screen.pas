{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
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
  textcolor(lightcyan);
  if dir[length(dir)] = '0' then
  begin  
    gotoxy(4,MINPOSY); writeln('Irrigator tube #1:');
    gotoxy(4,MINPOSY+1); writeln('Irrigator tube #2:');
    gotoxy(4,MINPOSY+2); writeln('Irrigator tube #3:');
  end else
  begin
    gotoxy(4,MINPOSY); writeln('Output #1 - lamp:');
    gotoxy(4,MINPOSY+1); writeln('Output #2 - ventilator:');
    gotoxy(4,MINPOSY+2); writeln('Output #3 - heater:');
  end;
  textcolor(white);
  for b:=1 to 3 do
  begin
    gotoxy(30,MINPOSY+b-1); writeln(outputs[b]);
  end;
end;
