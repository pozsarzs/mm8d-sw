{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage07screen.pas                                                      | }
{ | Show screen content of page #7                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [openweathermap.org]
  owm_enable=1
  owm_apikey=00000000000000000000000000000000
  owm_url=http://api.openweathermap.org/data/2.5/weather?
  owm_city=Tiszafoldvar
}

// write options to screen
procedure page07screen;
const
  PAGE=7;
var
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': OpenWeather.org account');
  block:=1;
  textcolor(lightcyan);
  gotoxy(4,MINPOSY[PAGE,block]); writeln('enable/disable:');
  gotoxy(4,MINPOSY[PAGE,block]+1); writeln('API key:');
  gotoxy(4,MINPOSY[PAGE,block]+2); writeln('URL:');
  gotoxy(4,MINPOSY[PAGE,block]+3); writeln('city:');
  textcolor(white);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(owm_enable);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+1); writeln(owm_apikey);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+2); writeln(owm_url);
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+3); writeln(owm_city);
end;
