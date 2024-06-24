{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incsaveinifile.pas                                                       | }
{ | Save configuration to ini file                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// save environment characteristics file
function saveinifile(filename: string): boolean;
var
  iif: text;
  b:   byte;

  // write header to file
  procedure fileheader;
  var
    b:  byte;
    l:  string;

    // completes the line to be 80 chars long
    function fullline(strin: string): string;
    begin
      fullline:='; | '+strin;
      repeat
        fullline:=fullline+' ';
      until length(fullline)>=79;
      fullline:=fullline+'|';
    end;

    begin
    l:='; +';
    for b:=1 to 76 do l:=l+'-';
    l:=l+'+';
    writeln(iif,l);
    writeln(iif,fullline('MM8D '+VERSION+' * Growing house and irrigation controlling and monitoring system'));
    writeln(iif,fullline(COPYRIGHT+' '));
    writeln(iif,fullline('mm8d.ini'));
    writeln(iif,fullline('Main settings'));
    writeln(iif,l);
    writeln(iif,'');
  end;

begin
  saveinifile:=true;
  try
    assign(iif,filename);
    rewrite(iif);
    fileheader;
    writeln(iif,';');
    writeln(iif,'; software');
    writeln(iif,';');
    writeln(iif,'');
    writeln(iif,'['+U+']');
    writeln(iif,'; user''s name');
    writeln(iif,'usr_name=',usr_name);
    writeln(iif,'');
    writeln(iif,'['+C+']');
    writeln(iif,'; name of the channels');
    for b:=0 to 8 do
      writeln(iif,'ch'+inttostr(b)+'_name='+ch_name[b]);
    writeln(iif,'');
    writeln(iif,'; enable/disable channels (0/1)');
    for b:=1 to 8 do
      writeln(iif,'ch'+inttostr(b)+'_enable'+inttostr(b)+'='+inttostr(ch_enable[b]));
    writeln(iif,'');
    writeln(iif,'['+A+']');
    writeln(iif,'; language of webpage (en/hu)');
    writeln(iif,'lng='+lng);
    writeln(iif,'');
    writeln(iif,'['+L+']');
    writeln(iif,'; storing time of the log files');
    writeln(iif,'log_day='+inttostr(log_day));
    writeln(iif,'; create verbose debug log file');
    writeln(iif,'log_debug='+inttostr(log_debug));
    writeln(iif,'; number of log lines on web interface');
    writeln(iif,'log_weblines='+inttostr(log_weblines));
    writeln(iif,'');
    writeln(iif,'['+D+']');
    writeln(iif,'; directories of program');
    writeln(iif,'dir_htm='+dir_htm);
    writeln(iif,'dir_lck='+dir_lck);
    writeln(iif,'dir_log='+dir_log);
    writeln(iif,'dir_msg='+dir_msg);
    writeln(iif,'dir_shr='+dir_shr);
    writeln(iif,'dir_tmp='+dir_tmp);
    writeln(iif,'dir_var='+dir_var);
    writeln(iif,'');
    writeln(iif,'['+O+']');
    writeln(iif,'; access data');
    writeln(iif,'owm_enable='+inttostr(owm_enable));
    writeln(iif,'owm_apikey='+owm_apikey);
    writeln(iif,'owm_url='+owm_url);
    writeln(iif,'owm_city='+owm_city);
    writeln(iif,'');
    writeln(iif,';');
    writeln(iif,'; hardware');
    writeln(iif,';');
    writeln(iif,'');
    writeln(iif,'['+I+']');
    writeln(iif,'; Serial port: GPIO14-15');
    writeln(iif,'');
    writeln(iif,'; local I/O ports');
    writeln(iif,'; DC 24-36 V inputs');
    for b:=1 to 5 do
      writeln(iif,'gpio_i'+inttostr(b)+'='+inttostr(gpio_i[b]));
    writeln(iif,'');
    writeln(iif,'; open collector outputs for LED');
    for b:=1 to 4 do
      writeln(iif,'gpio_lo'+inttostr(b)+'='+inttostr(gpio_lo[b]));
    writeln(iif,'');
    writeln(iif,'; relay outputs');
    for b:=1 to 8 do
      writeln(iif,'gpio_ro'+inttostr(b)+'='+inttostr(gpio_ro[b]));
    writeln(iif,'');
    writeln(iif,'; base addresses: 0x378, 0x278, 0x3BC');
    writeln(iif,'lpt_address=0x'+inttohex(lpt_address,3));
    writeln(iif,'');
    writeln(iif,'; DC 24-36 V inputs');
    writeln(iif,'# address BA+1');
    for b:=1 to 5 do
    begin
      writeln(iif,'lpt_i'+inttostr(b)+'_bit='+inttostr(lpt_i_bit[b]));
      writeln(iif,'lpt_i'+inttostr(b)+'_negation='+inttostr(lpt_i_negation[b]));
    end;
    writeln(iif,'');
    writeln(iif,'; open collector outputs for LED');
    writeln(iif,'# address BA+2');
    for b:=1 to 4 do
    begin
      writeln(iif,'lpt_lo'+inttostr(b)+'_bit='+inttostr(lpt_lo_bit[b]));
      writeln(iif,'lpt_lo'+inttostr(b)+'_negation='+inttostr(lpt_lo_negation[b]));
    end;
    writeln(iif,'');
    writeln(iif,'; relay outputs');
    writeln(iif,'# address BA+0');
    for b:=1 to 8 do
    begin
      writeln(iif,'lpt_ro'+inttostr(b)+'_bit='+inttostr(lpt_ro_bit[b]));
      writeln(iif,'lpt_ro'+inttostr(b)+'_negation='+inttostr(lpt_ro_negation[b]));
    end;
    writeln(iif,'');
    writeln(iif,';');
    writeln(iif,'; external devices');
    writeln(iif,';');
    writeln(iif,'');
    writeln(iif,'['+S+']');
    writeln(iif,'; mini serial console');
    writeln(iif,'msc_enable='+inttostr(msc_enable));
    writeln(iif,'msc_port='+msc_port);
    writeln(iif,'msc_speed='+inttostr(msc_speed));
    writeln(iif,'; level of verbosity of the log on console:');
    writeln(iif,';   0: nothing');
    writeln(iif,';   1: only error');
    writeln(iif,';   2: warning and error');
    writeln(iif,';   3: all');
    writeln(iif,'msc_verbose='+inttostr(msc_verbose));
    writeln(iif,'');
    writeln(iif,'['+P+']');
    writeln(iif,'; electric power meter');
    writeln(iif,'pwm_enable='+inttostr(pwm_enable));
    writeln(iif,'pwm_port='+pwm_port);
    writeln(iif,'pwm_speed='+inttostr(pwm_speed));
    writeln(iif,'pwm_modbusid='+inttostr(pwm_modbusid));
    writeln(iif,'pwm_handler='+pwm_handler);
    writeln(iif,'');
    writeln(iif,'['+F+']');
    writeln(iif,'; water flow meter');
    writeln(iif,'fwm_enable='+inttostr(fwm_enable));
    writeln(iif,'fwm_port='+fwm_port);
    writeln(iif,'fwm_speed='+inttostr(fwm_speed));
    writeln(iif,'fwm_modbusid='+inttostr(fwm_modbusid));
    writeln(iif,'fwm_handler='+fwm_handler);
    writeln(iif,'');
    writeln(iif,'['+T+']');
    writeln(iif,'; outdoor temperature meter');
    writeln(iif,'otm_enable='+inttostr(otm_enable));
    writeln(iif,'otm_port='+otm_port);
    writeln(iif,'otm_speed='+inttostr(otm_speed));
    writeln(iif,'otm_modbusid='+inttostr(otm_modbusid));
    writeln(iif,'otm_handler='+otm_handler);
    writeln(iif,'');
    writeln(iif,'['+Y+']');
    writeln(iif,'; display in the tent');
    writeln(iif,'tdp_enable='+inttostr(tdp_enable));
    writeln(iif,'tdp_port='+tdp_port);
    writeln(iif,'tdp_speed='+inttostr(tdp_speed));
    writeln(iif,'tdp_handler='+tdp_handler);
    for b:=1 to 8 do
      writeln(iif,'tdpch'+inttostr(b)+'_modbusid='+inttostr(tdpch_modbusid[b]));
    writeln(iif,'');
    writeln(iif,'['+M6+']');
    writeln(iif,'; grow house control device');
    writeln(iif,'; protocols: http, rtu, tcp');
    writeln(iif,'mm6d_protocol='+mm6d_protocol);
    writeln(iif,'mm6d_port='+mm6d_port);
    writeln(iif,'mm6d_speed='+inttostr(mm6d_speed));
    writeln(iif,'; using internal thermostat in the heater (timer control only)');
    writeln(iif,'mm6d_intthermostat='+inttostr(mm6d_intthermostat));
    for b:=1 to 8 do
    begin
      writeln(iif,'');
      writeln(iif,'mm6dch'+inttostr(b)+'_modbusid='+inttostr(mm6dch_modbusid[b]));
      writeln(iif,'mm6dch'+inttostr(b)+'_ipaddress='+mm6dch_ipaddress[b]);
    end;
    writeln(iif,'');
    writeln(iif,'['+M7+']');
    writeln(iif,'; T/RH measure device');
    writeln(iif,'; protocols: http, rtu, tcp');
    writeln(iif,'mm7d_protocol='+mm7d_protocol);
    writeln(iif,'mm7d_port='+mm7d_port);
    writeln(iif,'mm7d_speed='+inttostr(mm7d_speed));
    for b:=1 to 8 do
    begin
      writeln(iif,'');
      writeln(iif,'mm7dch'+inttostr(b)+'_modbusid='+inttostr(mm7dch_modbusid[b]));
      writeln(iif,'mm7dch'+inttostr(b)+'_ipaddress='+mm7dch_ipaddress[b]);
    end;
    writeln(iif,'');
    writeln(iif,'['+IPC+']');
    writeln(iif,'; tent and security IP cameras');
    writeln(iif,'; show tent camera on the webpage of channel');
    writeln(iif,'ipctent_enable='+inttostr(ipctent_enable));
    writeln(iif,'; snapshot url of the tent cameras');
    for b:=1 to 8 do
      writeln(iif,'ipctent'+inttostr(b)+'_url='+ipctent_url[b]);
    writeln(iif,'; snapshot url of the security cameras');
    writeln(iif,'ipcsec_enable='+inttostr(ipcsec_enable));
    for b:=1 to 5 do
      writeln(iif,'ipcsec'+inttostr(b)+'_url='+ipcsec_url[b]);
    close(iif);
  except
    saveinifile:=false;
  end;
end;
