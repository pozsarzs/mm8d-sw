{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage04screen.pas                                                      | }
{ | Show screen content of page #4                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [hyphae]
  vent_on=15
  vent_off=30
  vent_disable_??=1
  vent_lowtemp=15
  vent_disablelowtemp_??=1
}

// write options to screen
procedure page04screen;
var
  b: byte;
const
  PAGE=4;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing hyphae - ventilating 1');
  textcolor(white);
  // #1
  gotoxy(4,3); writeln('Ventilators switch-on minute:');
  gotoxy(4,4); writeln('Ventilators switch-off minute:');
  gotoxy(MINPOSX[PAGE,1]-1,3); if hventon<10 then write('0'); write(hventon);
  gotoxy(MINPOSX[PAGE,1]-1,4); if hventoff<10 then write('0'); write(hventoff);
  gotoxy(4,7); writeln('Disable ventilators (0/1):');
  // #2
  for b:=0 to 9 do
  begin
    gotoxy(MINPOSX[PAGE,2]-13,b+8);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',hventdis[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(MINPOSX[PAGE,2]-13,b+8);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdis[b]);
  end;
  // #3
  for b:=12 to 23 do
  begin
    gotoxy(MINPOSX[PAGE,3]-13,b-4);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdis[b]);
  end;
  // #4
  gotoxy(40,7); writeln('Disable if ext. temp. is low (0/1):');
  for b:=0 to 9 do
  begin
    gotoxy(MINPOSX[PAGE,4]-13,b+8);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',hventdislowtemp[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(MINPOSX[PAGE,4]-13,b+8);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdislowtemp[b]);
  end;
  // #5
  for b:=12 to 23 do
  begin
    gotoxy(MINPOSX[PAGE,5]-13,b-4);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdislowtemp[b]);
  end;
  // #6
  gotoxy(4,21); writeln('Low external temperature:');
  gotoxy(MINPOSX[PAGE,6],21);
  if hventlowtemp>9 then gotoxy(wherex-1,21);
  if hventlowtemp<0 then gotoxy(wherex-1,21);
  if hventlowtemp<-9 then gotoxy(wherex-1,21);
  writeln(hventlowtemp,' °C');
end;
