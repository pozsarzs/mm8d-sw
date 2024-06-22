{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage12screen.pas                                                      | }
{ | Show screen content of page #12                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [mm6d]
  mm6d_protocol=rtu
  mm6d_port=/dev/ttyS2
  mm6d_speed=9600
  mm6d_intthermostat=0
  mm6dch?_modbusid=0
  mm6dch?_ipaddress=0.0.0.0
}

// write options to screen
procedure page12screen;
const
  PAGE=12;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': MM6D devices');
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
  gotoxy(4,MINPOSY[PAGE,block]+3); write('timer control only:');
  textcolor(white);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); write(mm6dch_modbusid[b]);
  end;
  block:=2; 
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); write(mm6dch_ipaddress[b]);
  end;
  block:=3; 
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); write(mm6d_protocol);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); write(mm6d_port);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); write(mm6d_speed);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3); write(mm6d_intthermostat);
end;
