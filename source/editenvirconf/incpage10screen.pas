{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage10screen.pas                                                      | }
{ | Show screen content of page #10                                          | }
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
  vent_hightemp=26
  vent_disablehightemp_??=1
}

// write options to screen
procedure page10screen;
var
  b: byte;
  block: byte;
const
  PAGE=10;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing mushroom - ventilating 2');
  block:=1;
  textcolor(lightcyan);
  gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]-1); writeln('disable if outdoor T is high (0/1):');
  for b:=0 to 9 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-14,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00...'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdishightemp[b]);
  end;
  for b:=10 to 11 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdishightemp[b]);
  end;
  block:=2;
  for b:=12 to 23 do
  begin
    textcolor(lightcyan);
    gotoxy(MINPOSX[PAGE,block]-15,MINPOSY[PAGE,block]+b-12);
    write(' '+inttostr(b)+'.00..'+inttostr(b)+'.59: ');
    textcolor(white);
    writeln(mventdishightemp[b]);
  end;
  block:=3;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('high outdoor temperature:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]);
  if mventhightemp>9 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  if mventhightemp<0 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  if mventhightemp<-9 then gotoxy(wherex-1,MINPOSY[PAGE,block]);
  writeln(mventhightemp,' °C');
end;
