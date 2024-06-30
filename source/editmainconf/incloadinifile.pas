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
    fwm_enable:=strtoint(iif.ReadString(F,'fwm_enable','0'));
    fwm_handler:=iif.ReadString(F,'fwm_handler','');
    fwm_modbusid:=strtoint(iif.ReadString(F,'fwm_modbusid','0'));
    fwm_port:=iif.ReadString(F,'fwm_port','/dev/ttyS2');
    fwm_speed:=strtoint(iif.ReadString(F,'fwm_speed','9600'));
    ipc_gpio_enable:=strtoint(iif.ReadString(I,'ipc_gpio_enable','0'));
    ipc_gpio_handler:=iif.ReadString(I,'ipc_gpio_handler','');
    ipc_led_alarm:=strtoint(iif.ReadString(I,'ipc_led_alarm','0'));
    ipc_led_enable:=strtoint(iif.ReadString(I,'ipc_led_enable','0'));
    ipc_led_status:=strtoint(iif.ReadString(I,'ipc_led_status','0'));
    ipcsec_enable:=strtoint(iif.ReadString(IPC,'ipcsec_enable','0'));
    ipctent_enable:=strtoint(iif.ReadString(IPC,'ipctent_enable','0'));
    lng:=iif.ReadString('language','lng','en');
    log_day:=strtoint(iif.ReadString(L,'log_day','7'));
    log_debug:=strtoint(iif.ReadString(L,'log_debug','0'));
    log_weblines:=strtoint(iif.ReadString(L,'log_weblines','30'));
    lpt_address:=strtoint(iif.ReadString(L,'lpt_address','0x378'));
    mm6d_intthermostat:=strtoint(iif.ReadString(M6,'mm6d_intthermostat','0'));
    mm6d_port:=iif.ReadString(M6,'mm6d_port','/dev/ttyS2');
    mm6d_protocol:=iif.ReadString(M6,'mm6d_protocol','rtu');
    mm6d_speed:=strtoint(iif.ReadString(M6,'mm6d_speed','9600'));
    mm7d_port:=iif.ReadString(M7,'mm7d_port','/dev/ttyS2');
    mm7d_protocol:=iif.ReadString(M7,'mm7d_protocol','rtu');
    mm7d_speed:=strtoint(iif.ReadString(M7,'mm7d_speed','9600'));
    msc_enable:=strtoint(iif.ReadString(S,'msc_enable','1'));
    msc_port:=iif.ReadString(S,'msc_port','/dev/ttyS0');
    msc_speed:=strtoint(iif.ReadString(S,'msc_speed','9600'));
    msc_verbose:=strtoint(iif.ReadString(S,'msc_verbose','2'));
    otm_enable:=strtoint(iif.ReadString(T,'otm_enable','0'));
    otm_handler:=iif.ReadString(T,'otm_handler','');
    otm_modbusid:=strtoint(iif.ReadString(T,'otm_modbusid','0'));
    otm_port:=iif.ReadString(T,'otm_port','/dev/ttyS2');
    otm_speed:=strtoint(iif.ReadString(T,'otm_speed','9600'));
    owm_apikey:=iif.ReadString(O,'owm_apikey','');
    owm_city:=iif.ReadString(O,'owm_city','');
    owm_enable:=strtoint(iif.ReadString(O,'owm_enable','1'));
    owm_url:=iif.ReadString(O,'owm_url','http://api.openweathermap.org/data/2.5/weather?');
    pwm_enable:=strtoint(iif.ReadString(P,'pwm_enable','0'));
    pwm_handler:=iif.ReadString(P,'pwm_handler','');
    pwm_modbusid:=strtoint(iif.ReadString(P,'pwm_modbusid','0'));
    pwm_port:=iif.ReadString(P,'pwm_port','/dev/ttyS2');
    pwm_speed:=strtoint(iif.ReadString(P,'pwm_speed','9600'));
    tdp_enable:=strtoint(iif.ReadString(Y,'tdp_enable','0'));
    tdp_handler:=iif.ReadString(Y,'tdp_protocol','dm36b06');
    tdp_port:=iif.ReadString(Y,'tdp_port','/dev/ttyS2');
    tdp_speed:=strtoint(iif.ReadString(Y,'tdp_speed','9600'));
    usr_name:=iif.ReadString(U,'usr_name','');
    for b:=0 to 8 do
      ch_name[b]:=iif.ReadString(C,'ch'+inttostr(b)+'_name','');
    for b:=1 to 4 do
    begin
      gpio_lo[b]:=strtoint(iif.ReadString(I,'gpio_lo'+inttostr(b),'0'));
      ipc_gpio_i[b]:=strtoint(iif.ReadString(I,'ipc_gpio_i'+inttostr(b),'0'));
      ipc_gpio_ro[b]:=strtoint(iif.ReadString(I,'ipc_gpio_ro'+inttostr(b),'0'));
      ipcsec_url[b]:=iif.ReadString(IPC,'ipcsec'+inttostr(b)+'_url','');
      lpt_lo_bit[b]:=strtoint(iif.ReadString(I,'lpt_lo'+inttostr(b)+'_bit','0'));
      lpt_lo_negation[b]:=strtoint(iif.ReadString(I,'lpt_lo'+inttostr(b)+'_negation','0'));
    end;
    for b:=1 to 5 do
    begin
      gpio_i[b]:=strtoint(iif.ReadString(I,'gpio_i'+inttostr(b),'0'));
      lpt_i_bit[b]:=strtoint(iif.ReadString(I,'lpt_i'+inttostr(b)+'_bit','0'));
      lpt_i_negation[b]:=strtoint(iif.ReadString(I,'lpt_i'+inttostr(b)+'_negation','0'));
    end;
    for b:=1 to 8 do
    begin
      ch_enable[b]:=strtoint(iif.ReadString(C,'ch'+inttostr(b)+'_enable','0'));
      gpio_ro[b]:=strtoint(iif.ReadString(I,'gpio_ro'+inttostr(b),'0'));
      ipcsec_url[b]:=iif.ReadString(IPC,'ipcsec'+inttostr(b)+'_url','');
      ipctent_url[b]:=iif.ReadString(IPC,'ipctent'+inttostr(b)+'_url','');
      lpt_ro_bit[b]:=strtoint(iif.ReadString(I,'lpt_ro'+inttostr(b)+'_bit','0'));
      lpt_ro_negation[b]:=strtoint(iif.ReadString(I,'lpt_ro'+inttostr(b)+'_negation','0'));
      mm6dch_ipaddress[b]:=iif.ReadString(M6,'mm6dch'+inttostr(b)+'_ipaddress','');
      mm6dch_modbusid[b]:=strtoint(iif.ReadString(M6,'mm6dch'+inttostr(b)+'_modbusid','0'));
      mm7dch_ipaddress[b]:=iif.ReadString(M7,'mm7dch'+inttostr(b)+'_ipaddress','');
      mm7dch_modbusid[b]:=strtoint(iif.ReadString(M7,'mm7dch'+inttostr(b)+'_modbusid','0'));
      tdpch_modbusid[b]:=strtoint(iif.ReadString(Y,'tdpch'+inttostr(b)+'_modbusid','0'));
    end;
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
