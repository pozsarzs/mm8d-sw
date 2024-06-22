{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage02screen.pas                                                      | }
{ | Show screen content of page #2                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [tube-?]
  enable=1
  name=Tomato and eggplant
  morning_start=05:00
  morning_stop=05:30
  evening_start=19:00
  evening_stop=19:30
}

// write options to screen
procedure page02screen;
var
  block: byte;
const
  PAGE=2;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Irrigator tubes');
  for block:=1 to 3 do
  begin
    textcolor(lightcyan);
    gotoxy(4,MINPOSY[2,block]); writeln('name of tube #'+inttostr(block)+' :');
    gotoxy(4,MINPOSY[2,block]+1); writeln('enable irrigation:');
    gotoxy(4,MINPOSY[2,block]+2); writeln('start of morning irrigation:');
    gotoxy(4,MINPOSY[2,block]+3); writeln('end of morning irrigation:');
    gotoxy(4,MINPOSY[2,block]+4); writeln('start of evening irrigation:');
    gotoxy(4,MINPOSY[2,block]+5); writeln('end of evening irrigation:');
    textcolor(white);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]); writeln(name[block]);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]+1); writeln(enable[block]);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]+2); writeln(morningstart[block]);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]+3); writeln(morningstop[block]);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]+4); writeln(eveningstart[block]);
    gotoxy(MINPOSX[2,block],MINPOSY[2,block]+5); writeln(eveningstop[block]);
  end;
end;
