{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage6screen.pas                                                       | }
{ | Show screen content of page #6                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

procedure page6screen;
begin
  header(PRGNAME+' '+VERSION+' * Page 6/9: OpenWeather.org account');
  textcolor(white);
  gotoxy(4,3); writeln('API key:');
  gotoxy(4,4); writeln('URL:');
  gotoxy(4,5); writeln('Name of city:');
  gotoxy(MINPOSX[6,1],3); writeln(api_key);
  gotoxy(MINPOSX[6,1],4); writeln(base_url);
  gotoxy(MINPOSX[6,1],5); writeln(city_name);
end;
