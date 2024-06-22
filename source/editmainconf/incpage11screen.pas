{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage11screen.pas                                                      | }
{ | Show screen content of page #11                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [tentdisplay]
  tdp_enable=0
  tdp_port=/dev/ttyS2
  tdp_speed=9600
  tdp_handler=dm36b06
  tdpch?_modbusid=0
}

// write options to screen
procedure page11screen;
const
  PAGE=11;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Tent displays');
  textcolor(lightcyan);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b-1); write('Modbus ID of channel #'+inttostr(b)+':');
  end;
  block:=2; 
  gotoxy(4,MINPOSY[PAGE,block]); write('enable:');
  gotoxy(4,MINPOSY[PAGE,block]+1); write('serial port:');
  gotoxy(4,MINPOSY[PAGE,block]+2); write('baudrate:');
  gotoxy(4,MINPOSY[PAGE,block]+3); write('handler:');
  textcolor(white);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1); write(tdpch_modbusid[b]);
  end;
  block:=2; 
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); write(tdp_enable);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); write(tdp_port);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); write(tdp_speed);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3); write(tdp_handler);
end;
