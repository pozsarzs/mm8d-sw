{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage8screen.pas                                                       | }
{ | Show screen content of page #8                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page8screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 8/10: OpenWeather.org account');
  textcolor(white);
  gotoxy(4,3); writeln('API key:');
  gotoxy(4,4); writeln('URL:');
  gotoxy(4,5); writeln('Name of city:');
  gotoxy(MINPOSX[8,1],3); writeln(api_key);
  gotoxy(MINPOSX[8,1],4); writeln(base_url);
  gotoxy(MINPOSX[8,1],5); writeln(city_name);
end;
