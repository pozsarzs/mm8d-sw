{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage02screen.pas                                                      | }
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
  temperature_min=22
  heater_on=24
  heater_off=26
  temperature_max=27
  heater_disable_??=0
}

// write options to screen
procedure page07screen;
var
  b: byte;
const
  PAGE=7;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - heating');
  textcolor(white);
  // #1
  gotoxy(4,3); writeln('Minimal temperature:');
  gotoxy(4,4); writeln('Heating switch-on temperature:');
  gotoxy(4,5); writeln('Heating switch-off temperature:');
  gotoxy(4,6); writeln('Maximal temperature:');
  if mtempmin>9 then gotoxy(MINPOSX[PAGE,1]-1,3) else gotoxy(MINPOSX[PAGE,1],3); writeln(mtempmin,' °C');
  if mtempon>9 then gotoxy(MINPOSX[PAGE,1]-1,4) else gotoxy(MINPOSX[PAGE,1],4); writeln(mtempon,' °C');
  if mtempoff>9 then gotoxy(MINPOSX[PAGE,1]-1,5) else gotoxy(MINPOSX[PAGE,1],5); writeln(mtempoff,' °C');
  if mtempmax>9 then gotoxy(MINPOSX[PAGE,1]-1,6) else gotoxy(MINPOSX[PAGE,1],6); writeln(mtempmax,' °C');
  // #2
  gotoxy(4,9); writeln('Disable heater (0/1):');
  for b:=0 to 9 do
  begin
    gotoxy(MINPOSX[PAGE,2]-13,b+10);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(MINPOSX[PAGE,2]-13,b+10);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
  // #3
  for b:=12 to 23 do
  begin
    gotoxy(MINPOSX[PAGE,3]-13,b-2);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',mheaterdis[b]);
  end;
end;
