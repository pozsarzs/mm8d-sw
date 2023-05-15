{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage07screen.pas                                                      | }
{ | Show screen content of page #7                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [mushroom]
  temperature_min=8
  heater_on=15
  heater_off=17
  temperature_max=25
  heater_disable_??=0
}

// write options to screen
procedure page07screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/11: Growing mushroom - heating');
  textcolor(white);
  gotoxy(4,3); writeln('Minimal temperature:');
  gotoxy(4,4); writeln('Heating switch-on temperature:');
  gotoxy(4,5); writeln('Heating switch-off temperature:');
  gotoxy(4,6); writeln('Maximal temperature:');
  if mtempmin>9 then gotoxy(45,3) else gotoxy(46,3); writeln(mtempmin,' °C');
  if mtempon>9 then gotoxy(45,4) else gotoxy(46,4); writeln(mtempon,' °C');
  if mtempoff>9 then gotoxy(45,5) else gotoxy(46,5); writeln(mtempoff,' °C');
  if mtempmax>9 then gotoxy(45,6) else gotoxy(46,6); writeln(mtempmax,' °C');
  gotoxy(4,9); writeln('Disable heater (0/1):');
  for b:=0 to 9 do
  begin
    gotoxy(4,b+10);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(4,b+10);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
  for b:=12 to 23 do
  begin
    gotoxy(22,b-2);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
end;
