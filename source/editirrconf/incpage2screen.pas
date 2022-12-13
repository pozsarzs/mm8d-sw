{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.4 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage2screen.pas                                                       | }
{ | Show screen content of page #2                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page2screen;
var
  b: byte;
  x: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 2/2: Irrigator tubes');
  textcolor(white);
  x:=40;
  for b:=1 to 3 do
  begin
    gotoxy(4,3+7*(b-1)); writeln('name of tube #'+inttostr(b)+' :');
    gotoxy(4,4+7*(b-1)); writeln('start of morning irrigation:');
    gotoxy(4,5+7*(b-1)); writeln('end of morning irrigation:');
    gotoxy(4,6+7*(b-1)); writeln('start of evening irrigation:');
    gotoxy(4,7+7*(b-1)); writeln('end of evening irrigation:');
    gotoxy(x,3+7*(b-1)); writeln(name[b]);
    gotoxy(x,4+7*(b-1)); writeln(morningstart[b]);
    gotoxy(x,5+7*(b-1)); writeln(morningstop[b]);
    gotoxy(x,6+7*(b-1)); writeln(eveningstart[b]);
    gotoxy(x,7+7*(b-1)); writeln(eveningstop[b]);
  end;
end;
