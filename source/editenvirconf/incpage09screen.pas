{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage09screen.pas                                                      | }
{ | Show screen content of page #9                                           | }
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
  vent_on=15
  vent_off=30
  vent_disable_??=1
  vent_lowtemp=15
  vent_disablelowtemp_??=1
}

// write options to screen
procedure page09screen;
var
  b: byte;
  block: byte;
const
  PAGE=9;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - ventilating 1');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('ventilators switch-on minute:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('ventilators switch-off minute:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]); if mventon<10 then write('0'); write(mventon);
  gotoxy(MINPOSX[PAGE,block]-1,MINPOSY[PAGE,block]+1); if mventoff<10 then write('0'); write(mventoff);
  block:=2;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]-1); writeln('disable ventilators (0/1):');
  for b:=0 to 9 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-14,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00...'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdis[b]);
  end;
  for b:=10 to 11 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdis[b]);
  end;
  block:=3;
  for b:=12 to 23 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b-12);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdis[b]);
  end;
  block:=4;
  textcolor(lightcyan);
  gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]-1); writeln('disable if outdoor T is low (0/1):');
  for b:=0 to 9 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-14,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00...'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdislowtemp[b]);
  end;
  for b:=10 to 11 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdislowtemp[b]);
  end;
  block:=5;
  for b:=12 to 23 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b-12);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdislowtemp[b]);
  end;
  block:=6;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('low external temperature:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]);
  if mventlowtemp>9 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  if mventlowtemp<0 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  if mventlowtemp<-9 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  writeln(mventlowtemp,' °C');
end;
