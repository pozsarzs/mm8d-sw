{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage08screen.pas                                                      | }
{ | Show screen content of page #08                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [localio]
  gpio_i?=2
  gpio_lo?=16
  gpio_ro?=20

  ipc_gpio_enable=0
  ipc_gpio_i?=24
  ipc_gpio_ro?=20
  ipc_led_enable=1
  ipc_led_alarm=1
  ipc_led_status=0
  ipc_gpio_handler=nice3120gpio
}

// write options to screen
procedure page08screen;
const
  PAGE=8;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': GPIO port');
  textcolor(lightcyan);
  block:=1;
  gotoxy(4,MINPOSY[PAGE,block]-1); write('Raspberry Pi:');
  for b:=1 to 17 do
  begin
    gotoxy(5,MINPOSY[PAGE,block]+b-1);
    if b<=5 then write('input i'+inttostr(b)+':');
    if (b>5) and (b<=9) then write('LED output lo'+inttostr(b-5)+':');
    if (b>9) then write('relay output ro'+inttostr(b-9)+':');
  end;
  block:=2;
  gotoxy(45,MINPOSY[PAGE,block]-1); write('industrial PC:');
  for b:=1 to 17 do
  begin
    gotoxy(46,MINPOSY[PAGE,block]+b-1);
    if b<=5 then write('input i'+inttostr(b)+':');
    if (b>5) and (b<=9) then write('LED output lo'+inttostr(b-5)+':');
    if (b>9) then write('relay output ro'+inttostr(b-9)+':');
  end;
  block:=3;
  gotoxy(45,MINPOSY[PAGE,block]); write('enable GPIO port:');
  gotoxy(45,MINPOSY[PAGE,block]+1); write('enable LEDs:');
  gotoxy(45,MINPOSY[PAGE,block]+2); write('handler module:');
  textcolor(white);
  block:=1;
  for b:=1 to 17 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    if b<=5 then write(gpio_i[b]);
    if (b>5) and (b<=9) then write(gpio_lo[b-5]);
    if (b>9) then write(gpio_ro[b-9]);
  end;
  block:=2;
  for b:=1 to 17 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    if b<=4 then write(ipc_gpio_i[b]);
    if b=6 then write(ipc_led_status);
    if b=8 then write(ipc_led_alarm);
    if (b>9) and (b<=13) then write(ipc_gpio_ro[b-9]);
  end;
  block:=3;
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); write(ipc_gpio_enable);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); write(ipc_led_enable);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); write(ipc_gpio_enable);
end;
