{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
  api_key=00000000000000000000000000000000
  base_url=http://api.openweathermap.org/data/2.5/weather?
  city_name=Tiszafoldvar
}

// write options to screen
procedure page07screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 7/12: OpenWeather.org account');
  textcolor(white);
  gotoxy(4,3); writeln('API key:');
  gotoxy(4,4); writeln('URL:');
  gotoxy(4,5); writeln('Name of city:');
  gotoxy(MINPOSX[7,1],3); writeln(api_key);
  gotoxy(MINPOSX[7,1],4); writeln(base_url);
  gotoxy(MINPOSX[7,1],5); writeln(city_name);
end;
