{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
  nam_ch?=channel name
}

// write options to screen
procedure page02screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 2/12: Channel names');
  textcolor(white);
  for b:=0 to 8 do
  begin
    gotoxy(4,b+1+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=0 to 8 do
  begin
    gotoxy(MINPOSX[2,1],b+1+2);
    writeln(nam_ch[b]);
  end;
end;
