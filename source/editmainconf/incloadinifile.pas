{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
    dir_htm:=iif.ReadString(D,'dir_htm','/var/www/html/');
    dir_lck:=iif.ReadString(D,'dir_lck','/var/lock/');
    dir_log:=iif.ReadString(D,'dir_log','/var/log/');
    dir_msg:=iif.ReadString(D,'dir_msg','/usr/share/locale/');
    dir_shr:=iif.ReadString(D,'dir_shr','/usr/share/mm8d/');
    dir_tmp:=iif.ReadString(D,'dir_tmp','/var/tmp/');
    dir_var:=iif.ReadString(D,'dir_var','/var/lib/mm8d/');
    ipcsec_enable:=strtoint(iif.ReadString(IPC,'ipcsec_enable','0'));
    ipctent_enable:=strtoint(iif.ReadString(IPC,'ipctent_enable','0'));
    lng:=iif.ReadString('language','lng','en');
    log_day:=strtoint(iif.ReadString(L,'log_day','7'));
    log_debug:=strtoint(iif.ReadString(L,'log_debug','0'));
    log_weblines:=strtoint(iif.ReadString(L,'log_weblines','30'));
    mm6d_intthermostat:=strtoint(iif.ReadString(M6,'mm6d_intthermostat','0'));
    mm6d_port:=iif.ReadString(M6,'mm6d_port','/dev/ttyS2');
    mm6d_protocol:=iif.ReadString(M6,'mm6d_protocol','rtu');
    mm6d_speed:=strtoint(iif.ReadString(M6,'mm6d_speed','9600'));
    mm7d_port:=iif.ReadString(M7,'mm7d_port','/dev/ttyS2');
    mm7d_protocol:=iif.ReadString(M7,'mm7d_protocol','rtu');
    mm7d_speed:=strtoint(iif.ReadString(M7,'mm7d_speed','9600'));
    owm_apikey:=iif.ReadString(O,'owm_apikey','');
    owm_city:=iif.ReadString(O,'owm_city','');
    owm_enable:=strtoint(iif.ReadString(O,'owm_enable','1'));
    owm_url:=iif.ReadString(O,'owm_url','http://api.openweathermap.org/data/2.5/weather?');
    tdp_enable:=strtoint(iif.ReadString(O,'tdp_enable','0'));
    tdp_handler:=iif.ReadString(M6,'tdp_protocol','dm36b06');
    tdp_port:=iif.ReadString(M6,'tdp_port','/dev/ttyS2');
    tdp_speed:=strtoint(iif.ReadString(M6,'tdp_speed','9600'));
    usr_name:=iif.ReadString(U,'usr_name','');
    for b:=0 to 8 do
      ch_name[b]:=iif.ReadString(C,'ch'+inttostr(b)+'_name','');
    for b:=1 to 4 do
    begin
      gpio_lo[b]:=strtoint(iif.ReadString(I,'gpio_lo'+inttostr(b),'0'));
      ipcsec_url[b]:=iif.ReadString(IPC,'ipcsec'+inttostr(b)+'_url','');
    end;
    for b:=1 to 5 do
      gpio_i[b]:=strtoint(iif.ReadString(I,'gpio_i'+inttostr(b),'0'));
    for b:=1 to 8 do
    begin
      ch_enable[b]:=strtoint(iif.ReadString(C,'ch'+inttostr(b)+'_enable','0'));
      gpio_ro[b]:=strtoint(iif.ReadString(I,'gpio_ro'+inttostr(b),'0'));
      ipcsec_url[b]:=iif.ReadString(IPC,'ipcsec'+inttostr(b)+'_url','');
      ipctent_url[b]:=iif.ReadString(IPC,'ipctent'+inttostr(b)+'_url','');
      mm6dch_ipaddress[b]:=iif.ReadString(M6,'mm6dch'+inttostr(b)+'_ipaddress','');
      mm6dch_modbusid[b]:=strtoint(iif.ReadString(M6,'mm6dch'+inttostr(b)+'_modbusid','0'));
      mm7dch_ipaddress[b]:=iif.ReadString(M7,'mm7dch'+inttostr(b)+'_ipaddress','');
      mm7dch_modbusid[b]:=strtoint(iif.ReadString(M7,'mm7dch'+inttostr(b)+'_modbusid','0'));
      tdpch_modbusid[b]:=strtoint(iif.ReadString(Y,'tdpch'+inttostr(b)+'_modbusid','0'));
    end;
    // ** átnézendő **
    //com_speed:=iif.ReadString(C,'com_speed','9600');
    //com_verbose:=strtoint(iif.ReadString(C,'com_verbose','2'));
    //ena_console:=strtoint(iif.ReadString(C,'ena_console','1'));
    //prt_com:=iif.ReadString(C,'prt_com','/dev/ttyS0');
    //prt_lpt:=strtoint(iif.ReadString(L,'prt_lpt','1'));
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
