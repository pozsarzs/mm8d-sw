{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage02screen.pas                                                      | }
{ | Show screen content of page #2                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [names]
  ch?_name=channel name
}

// write options to screen
procedure page02screen;
var
  b: byte;
  block: byte;
const
  PAGE=2;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': Channel names');
  block:=1;
  textcolor(lightcyan);
  for b:=0 to 8 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b);
    write('channel #'+inttostr(b)+':');
  end;
  textcolor(white);
  for b:=0 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b);
    writeln(ch_name[b]);
  end;
end;
