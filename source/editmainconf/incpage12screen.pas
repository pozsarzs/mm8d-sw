{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
  ena_tentcams=0
  ena_seccams=0
  cam_ch?=http://camera-tc1.lan/snapshot.cgi?user=username&pwd=password
  cam_sc?=http://camera-sc1.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
}

// write options to screen
procedure page12screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 12/' + inttostr(LASTPAGE) + ': URL of IP cameras');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=1 to 5 do
  begin
    gotoxy(4,b+13);
    write('Security camera #'+inttostr(b)+':');
  end;
  gotoxy(4,12); write('Show tent camera snapshots:');
  gotoxy(4,20); write('Show security camera snapshots:');
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[12,1],b+2);
    writeln(cam_ch[b]);
  end;
  gotoxy(MINPOSX[12,2],12); writeln(ena_tentcams);
  for b:=1 to 5 do
  begin
    gotoxy(MINPOSX[12,3],b+13);
    writeln(cam_sc[b]);
  end;
  gotoxy(MINPOSX[12,2],20); writeln(ena_tentcams);
end;
