{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
  block: byte;
const
  PAGE=7;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - heating');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('minimal temperature:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('heating switch-on temperature:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('heating switch-off temperature:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('maximal temperature:');
  textcolor(white);
  if mtempmin>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]) else gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(mtempmin,' °C');
  if mtempon>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+1) else gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); writeln(mtempon,' °C');
  if mtempoff>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+2) else gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); writeln(mtempoff,' °C');
  if mtempmax>9 then gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+3) else gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3); writeln(mtempmax,' °C');
  block:=2;
  textcolor(lightcyan);
  gotoxy(4,9); writeln('disable heater (0/1):');
  for b:=0 to 9 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-14,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00...'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mheaterdis[b]);
  end;
  for b:=10 to 11 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mheaterdis[b]);
  end;
  block:=3;
  for b:=12 to 23 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b-12);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mheaterdis[b]);
  end;
end;
