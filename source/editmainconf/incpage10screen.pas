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

  [console]
  msc_enable=1
  msc_port=/dev/ttyS0
  msc_speed=9600
  msc_verbose=2

  [powermeter]
  pwm_enable=1
  pwm_port=/dev/ttyS1
  pwm_speed=9600
  pwm_modbusid=1
  pwm_handler=dt510

  [flowmeter]
  fwm_enable=0
  fwm_port=/dev/ttyS2
  fwm_speed=9600
  fwm_modbusid=0
  fwm_handler=

  [outdoortempmeter]
  otm_enable=1
  otm_port=/dev/ttyS2
  otm_speed=9600
  otm_modbusid=20
  otm_handler=pta9b01
}

// write options to screen
procedure page10screen;
const
  PAGE=10;
var
  b: byte;
  block: byte;
  x: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Serial devices');
  for block:=1 to 4 do
  begin
    textcolor(lightcyan);
    if block > 2 then x:=45 else x:=5;
    gotoxy(x-1,MINPOSY[PAGE,block]-1);
    case block of
      1: write('mini serial console');
      2: write('electric power meter');
      3: write('water flow meter');
      4: write('outdoor temperature meter');
    end;
    write(':');
    gotoxy(x,MINPOSY[PAGE,block]); write('enable:');
    gotoxy(x,MINPOSY[PAGE,block]+1); write('serial port:');
    gotoxy(x,MINPOSY[PAGE,block]+2); write('baudrate:');
    if block=1 then
    begin
      gotoxy(x,MINPOSY[PAGE,block]+3); write('verbose mode:');
    end else
    begin
      gotoxy(x,MINPOSY[PAGE,block]+3); write('Modbus ID:');
      gotoxy(x,MINPOSY[PAGE,block]+4); write('handler module:');
    end;
    textcolor(white);
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]);
    case block of
      1: write(msc_enable);
      2: write(pwm_enable);
      3: write(fwm_enable);
      4: write(otm_enable);
    end;
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1);
    case block of
      1: write(msc_port);
      2: write(pwm_port);
      3: write(fwm_port);
      4: write(otm_port);
    end;
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2);
    case block of
      1: write(msc_speed);
      2: write(pwm_speed);
      3: write(fwm_speed);
      4: write(otm_speed);
    end;
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3);
    case block of
      1: write(msc_verbose);
      2: write(pwm_modbusid);
      3: write(fwm_modbusid);
      4: write(otm_modbusid);
    end;
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+4);
    case block of
      2: write(pwm_handler);
      3: write(fwm_handler);
      4: write(otm_handler);
    end;
  end;
end;
