{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage12screen.pas                                                      | }
{ | Show screen content of page #12                                          | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

{
  Relevant settings file section:

  [IPcamera]
  ena_cameras=0
  cam_ch?=http://camera11.lan/snapshot.cgi?user=username&pwd=password
  cam_sc?=http://camera01.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
}

// write options to screen
procedure page12screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 12/12: URL of IP cameras');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=1 to 4 do
  begin
    gotoxy(4,b+13);
    write('Security camera #'+inttostr(b)+':');
  end;
  gotoxy(4,12); write('Show camera snapshots:');
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[12,1],b+2);
    writeln(cam_ch[b]);
  end;
  gotoxy(MINPOSX[12,2],12); writeln(ena_cameras);
  for b:=1 to 4 do
  begin
    gotoxy(MINPOSX[12,3],b+13);
    writeln(cam_sc[b]);
  end;
end;
