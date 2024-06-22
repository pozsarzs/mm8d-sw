{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incpage14screen.pas                                                      | }
{ | Show screen content of page #14                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:p

  [ipcamera]
  ipctent_enable=0
  ipctent?_url=http://camera-tc1.lan/snapshot.cgi?user=username&pwd=password

  ipcsec_enable=0
  ipcsec?_url==http://camera-sc1.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
}

// write options to screen
procedure page14screen;
const
  PAGE=14;
var
  b: byte;
  block: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page '+inttostr(PAGE)+'/'+inttostr(LASTPAGE)+': IP cameras');
  block:=1;
  textcolor(lightcyan);
  for b:=1 to 8 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b-1);
    write('channel #'+inttostr(b)+':');
  end;
  block:=2;
  gotoxy(4,MINPOSY[PAGE,block]); write('show tent camera snapshots:');
  block:=3;
  for b:=1 to 5 do
  begin
    gotoxy(4,MINPOSY[PAGE,block]+b-1);
    write('outdoor #'+inttostr(b)+':');
  end;
  block:=4;
  gotoxy(4,MINPOSY[PAGE,block]); write('show outdoor camera snapshots:');
  textcolor(white);
  block:=1;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    writeln(copy(ipctent_url[b],0,screenwidth-MINPOSX[PAGE,block]));
  end;
  block:=2;
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(ipctent_enable);
  block:=3;
  for b:=1 to 5 do
  begin
    gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]+b-1);
    writeln(copy(ipcsec_url[b],0,screenwidth-MINPOSX[PAGE,block]));
  end;
  block:=4;
  gotoxy(MINPOSX[PAGE,block],MINPOSY[PAGE,block]); writeln(ipcsec_enable);
end;
