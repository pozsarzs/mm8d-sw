{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage13screen.pas                                                      | }
{ | Show screen content of page #13                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [mm7d]
  mm7d_protocol=rtu
  mm7d_port=/dev/ttyS2
  nn7d_speed=9600
  mm7dch?_modbusid=0
  mm7dch?_ipaddress=0.0.0.0
}

// write options to screen
procedure page13screen;
const
  PAGE=13;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': MM7D devices');
  textcolor(lightcyan);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('Modbus ID of channel #'+inttostr(b)+':');
  end;
  block:=2; 
  for b:=1 to 8 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('IP address of channel #'+inttostr(b)+':');
  end;
  block:=3; 
  gotoxy(4,MINPOSY[PAGE,block]); write('protocol (http/tcp/rtu):');
  gotoxy(4,MINPOSY[PAGE,block]+1); write('serial port:');
  gotoxy(4,MINPOSY[PAGE,block]+2); write('baudrate:');
  textcolor(white);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); write(mm7dch_modbusid[b]);
  end;
  block:=2; 
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); write(mm7dch_ipaddress[b]);
  end;
  block:=3; 
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); write(mm7d_protocol);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); write(mm7d_port);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); write(mm7d_speed);
end;
