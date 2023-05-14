{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.4 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incloadinifile.pas                                                       | }
{ | Load configuration from ini file                                         | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
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
    for b:=1 to 3 do
      usr_dt[b]:=iif.ReadString(U,'usr_dt'+inttostr(b),'');
    for b:=0 to 8 do
      nam_ch[b]:=iif.ReadString(N,'nam_ch'+inttostr(b),'');
    for b:=1 to 8 do
    begin
      ena_ch[b]:=strtoint(iif.ReadString(E,'ena_ch'+inttostr(b),'0'));
      adr_mm6dch[b]:=iif.ReadString(M6,'adr_mm6dch'+inttostr(b),'');
      adr_mm7dch[b]:=iif.ReadString(M7,'adr_mm7dch'+inttostr(b),'');
      cam_ch[b]:=iif.ReadString(I,'cam_ch'+inttostr(b),'');
    end;
    for b:=1 to 4 do
    begin
      prt_i[b]:=strtoint(iif.ReadString(G,'prt_i'+inttostr(b),''));
      prt_ro[b]:=strtoint(iif.ReadString(G,'prt_ro'+inttostr(b),''));
      prt_lo[b]:=strtoint(iif.ReadString(G,'prt_lo'+inttostr(b),''));
    end;
    lpt_prt:=strtoint(iif.ReadString(L,'prt_lpt',''));

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
    api_key:=iif.ReadString(W,'api_key','');
    base_url:=iif.ReadString(W,'base_url','http://api.openweathermap.org/data/2.5/weather?');
    city_name:=iif.ReadString(W,'city_name','');
    cam_show:=strtoint(iif.ReadString(I,'cam_show','0'));
    lng:=iif.ReadString(A,'lng','');
    day_log:=strtoint(iif.ReadString(O,'day_log','7'));
    dbg_log:=strtoint(iif.ReadString(O,'dbg_log','0'));
    web_lines:=strtoint(iif.ReadString(O,'web_lines','30'));
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
