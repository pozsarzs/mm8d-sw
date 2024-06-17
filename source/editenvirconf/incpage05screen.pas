{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage05screen.pas                                                      | }
{ | Show screen content of page #5                                           | }
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
  vent_hightemp=26
  vent_disablehightemp_??=1
}

// write options to screen
procedure page05screen;
var
  b: byte;
const
  PAGE=5;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Growing hyphae - ventilating 2');
  textcolor(white);
  // #1
  gotoxy(4,3); writeln('Disable if ext. temp. is high (0/1):');
  for b:=0 to 9 do
  begin
    gotoxy(MINPOSX[PAGE,1]-13,b+4);
    writeln(' '+inttostr(b)+'.00...'+inttostr(b)+'.59 ',hventdishightemp[b]);
  end;
  for b:=10 to 11 do
  begin
    gotoxy(MINPOSX[PAGE,1]-13,b+4);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdishightemp[b]);
  end;
  // #2
  for b:=12 to 23 do
  begin
    gotoxy(MINPOSX[PAGE,2]-13,b-8);
    writeln(inttostr(b)+'.00..'+inttostr(b)+'.59 ',hventdishightemp[b]);
  end;
  gotoxy(4,17); writeln('High external temperature:');
  // #3
  gotoxy(MINPOSX[PAGE,3],17);
  if hventhightemp>9 then gotoxy(wherex-1,17);
  if hventhightemp<0 then gotoxy(wherex-1,17);
  if hventhightemp<-9 then gotoxy(wherex-1,17);
  writeln(hventhightemp,' °C');
end;
