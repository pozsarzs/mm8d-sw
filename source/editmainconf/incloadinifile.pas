{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incloadinifile.pas                                                       | }
{ | Load configuration from ini file                                         | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// load environment characteristics file
function loadinifile(filename: string): boolean;
var
  iif: TINIFile;
  b:   byte;

begin
  iif:=TIniFile.Create(filename);
  loadinifile:=true;
  try
    usr_nam:=iif.ReadString(U,'usr_nam','');
    usr_uid:=iif.ReadString(U,'usr_uid','');
    for b:=0 to 8 do
      nam_ch[b]:=iif.ReadString(N,'nam_ch'+inttostr(b),'');
    for b:=1 to 8 do
    begin
      ena_ch[b]:=strtoint(iif.ReadString(E,'ena_ch'+inttostr(b),'0'));
      adr_mm6dch[b]:=iif.ReadString(M6,'adr_mm6dch'+inttostr(b),'');
      adr_mm7dch[b]:=iif.ReadString(M7,'adr_mm7dch'+inttostr(b),'');
      pro_mm6dch[b]:=iif.ReadString(M6,'adr_mm6dch'+inttostr(b),'http');
      pro_mm7dch[b]:=iif.ReadString(M7,'adr_mm7dch'+inttostr(b),'http');
      uid_mm6dch[b]:=iif.ReadString(M6,'adr_mm6dch'+inttostr(b),'1');
      uid_mm7dch[b]:=iif.ReadString(M7,'adr_mm7dch'+inttostr(b),'1');
      cam_ch[b]:=iif.ReadString(I,'cam_ch'+inttostr(b),'');
      if b<5 then
        cam_sc[b]:=iif.ReadString(I,'cam_sc'+inttostr(b),'');
    end;
    for b:=1 to 4 do
    begin
      prt_i[b]:=strtoint(iif.ReadString(G,'prt_i'+inttostr(b),'0'));
      prt_ro[b]:=strtoint(iif.ReadString(G,'prt_ro'+inttostr(b),'0'));
      prt_lo[b]:=strtoint(iif.ReadString(G,'prt_lo'+inttostr(b),'0'));
    end;
    com_speed:=iif.ReadString(C,'com_speed','9600');
    com_verbose:=strtoint(iif.ReadString(C,'com_verbose','2'));
    ena_console:=strtoint(iif.ReadString(C,'ena_console','1'));
    prt_com:=iif.ReadString(C,'prt_com','/dev/ttyS0');
    prt_lpt:=strtoint(iif.ReadString(L,'prt_lpt','1'));
    dir_htm:=iif.ReadString(D,'dir_htm','/var/www/html/');
    dir_tmp:=iif.ReadString(D,'dir_tmp','/var/tmp/');
{$IFDEF USRLOCALDIR}
    dir_lck:=iif.ReadString(D,'dir_lck','/var/local/lock/');
    dir_log:=iif.ReadString(D,'dir_log','/var/local/log/');
    dir_msg:=iif.ReadString(D,'dir_msg','/usr/local/share/locale/');
    dir_shr:=iif.ReadString(D,'dir_shr','/usr/local/share/mm8d/');
    dir_var:=iif.ReadString(D,'dir_var','/var/local/lib/mm8d/');
{$ELSE}
    dir_lck:=iif.ReadString(D,'dir_lck','/var/lock/');
    dir_log:=iif.ReadString(D,'dir_log','/var/log/');
    dir_msg:=iif.ReadString(D,'dir_msg','/usr/share/locale/');
    dir_shr:=iif.ReadString(D,'dir_shr','/usr/share/mm8d/');
    dir_var:=iif.ReadString(D,'dir_var','/var/lib/mm8d/');
{$ENDIF}
    adr_mm10d:=iif.ReadString(M10,'adr_mm10d','');
    api_key:=iif.ReadString(W,'api_key','');
    base_url:=iif.ReadString(W,'base_url','http://api.openweathermap.org/data/2.5/weather?');
    city_name:=iif.ReadString(W,'city_name','');
    day_log:=strtoint(iif.ReadString(O,'day_log','7'));
    dbg_log:=strtoint(iif.ReadString(O,'dbg_log','0'));
    ena_cameras:=strtoint(iif.ReadString(I,'ena_cameras','0'));
    ena_mm10d:=strtoint(iif.ReadString(M10,'ena_mm10d','1'));
    lng:=iif.ReadString('language','lng','en');
    pro_mm10d:=iif.ReadString(M10,'adr_mm10d','http');
    uid_mm10d:=iif.ReadString(M10,'adr_mm10d','1');
    web_lines:=strtoint(iif.ReadString(O,'web_lines','30'));
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
