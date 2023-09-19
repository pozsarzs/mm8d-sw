{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage01screen.pas                                                      | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [user]
  usr_nam=Szerafin Gomba Tiszaföldvár
  usr_uid=00000000
}

// write options to screen
procedure page01screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 1/12: User data');
  textcolor(white);
  gotoxy(4,3); write('User''s name:');
  gotoxy(4,4); write('User''s ID:');
  gotoxy(MINPOSX[1,1],3); write(usr_nam);
  gotoxy(MINPOSX[1,1],4); write(usr_uid);
end;
