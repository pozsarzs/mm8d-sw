{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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
    writeln(iif,fullline('MM8D v'+VERSION+' * Growing house and irrigation controlling and monitoring system'));
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
    writeln(iif,'; user''s data');
    writeln(iif,'usr_nam=',usr_nam);
    writeln(iif,'usr_uid=',usr_uid);
    writeln(iif,'');
    writeln(iif,'['+N+']');
    writeln(iif,'; name of channels');
    for b:=0 to 8 do
      writeln(iif,'nam_ch'+inttostr(b)+'='+nam_ch[b]);
    writeln(iif,'');
    writeln(iif,'['+E+']');
    writeln(iif,'; enable/disable channels (0/1)');
    for b:=1 to 8 do
      writeln(iif,'ena_ch'+inttostr(b)+'='+inttostr(ena_ch[b]));
    writeln(iif,'');
    writeln(iif,'['+A+']');
    writeln(iif,'; language of webpage (en/hu)');
    writeln(iif,'lng='+lng);
    writeln(iif,'');
    writeln(iif,'['+O+']');
    writeln(iif,'; storing time of the log files');
    writeln(iif,'day_log='+inttostr(day_log));
    writeln(iif,'; create verbose debug log file');
    writeln(iif,'dbg_log='+inttostr(dbg_log));
    writeln(iif,'; number of log lines on web interface');
    writeln(iif,'web_lines='+inttostr(web_lines));
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
    writeln(iif,'['+W+']');
    writeln(iif,'; access data');
    writeln(iif,'api_key='+api_key);
    writeln(iif,'base_url='+base_url);
    writeln(iif,'city_name='+city_name);
    writeln(iif,'');
    writeln(iif,';');
    writeln(iif,'; hardware');
    writeln(iif,';');
    writeln(iif,'');
    writeln(iif,'['+G+']');
    writeln(iif,'; number of the used GPIO ports');
    for b:=1 to 4 do
      writeln(iif,'prt_i'+inttostr(b)+'='+inttostr(prt_i[b]));
    for b:=1 to 4 do
      writeln(iif,'prt_ro'+inttostr(b)+'='+inttostr(prt_ro[b]));
    for b:=1 to 4 do
      writeln(iif,'prt_lo'+inttostr(b)+'='+inttostr(prt_lo[b]));
    writeln(iif,'');
    writeln(iif,'['+L+']');
    writeln(iif,'; address of the used LPT port (0x378: 0, 0x278: 1, 0x3BC: 2)');
    writeln(iif,'lpt_prt='+inttostr(prt_lpt));
    writeln(iif,'');
    writeln(iif,'['+C+']');
    writeln(iif,'; enable/disable external serial display (0/1)');
    writeln(iif,'ena_console='+inttostr(ena_console));
    writeln(iif,'; port name');
    writeln(iif,'prt_com='+prt_com);
    writeln(iif,'; port speed');
    writeln(iif,'com_speed='+com_speed);
    writeln(iif,'; level of verbosity of the log on console');
    writeln(iif,'; (nothing: 0, only error: 1, warning and error: 2, all: 3)');
    writeln(iif,'com_verbose='+inttostr(com_verbose));
    writeln(iif,'');
    writeln(iif,';');
    writeln(iif,'; external devices');
    writeln(iif,';');
    writeln(iif,'');
    writeln(iif,'['+M6+']');
    writeln(iif,'; protocol (http/modbus)');
    for b:=1 to 8 do
      writeln(iif,'pro_mm6dch'+inttostr(b)+'='+pro_mm6dch[b]);
    writeln(iif,'');
    writeln(iif,'; IP address');
    for b:=1 to 8 do
      writeln(iif,'adr_mm6dch'+inttostr(b)+'='+adr_mm6dch[b]);
    writeln(iif,'');
    writeln(iif,'; ModBUS unitID');
    for b:=1 to 8 do
      writeln(iif,'uid_mm6dch'+inttostr(b)+'='+uid_mm6dch[b]);
    writeln(iif,'');
    writeln(iif,'['+M7+']');
    writeln(iif,'; protocol (http/modbus)');
    for b:=1 to 8 do
      writeln(iif,'pro_mm7dch'+inttostr(b)+'='+pro_mm7dch[b]);
    writeln(iif,'');
    writeln(iif,'; IP address');
    for b:=1 to 8 do
      writeln(iif,'adr_mm7dch'+inttostr(b)+'='+adr_mm7dch[b]);
    writeln(iif,'');
    writeln(iif,'; ModBUS unitID');
    for b:=1 to 8 do
      writeln(iif,'uid_mm7dch'+inttostr(b)+'='+uid_mm7dch[b]);
    writeln(iif,'');
    writeln(iif,'['+M10+']');
    writeln(iif,'; enable/disable handling (0/1)');
    writeln(iif,'ena_mm10d='+inttostr(ena_mm10d));
    writeln(iif,'; protocol (http/modbus)');
    writeln(iif,'pro_mm10d='+pro_mm10d);
    writeln(iif,'; IP address');
    writeln(iif,'adr_mm10d='+adr_mm10d);
    writeln(iif,'; ModBUS unitID');
    writeln(iif,'uid_mm10d='+uid_mm10d);
    writeln(iif,'');
    writeln(iif,'['+I+']');
    writeln(iif,'; show tent camera on the webpage of channel (0/1)');
    writeln(iif,'ena_tentcams='+inttostr(ena_tentcams));
    writeln(iif,'; snapshot url of the tent cameras');
    for b:=1 to 8 do
      writeln(iif,'cam_ch'+inttostr(b)+'='+cam_ch[b]);
    writeln(iif,'; snapshot url of the security cameras');
    writeln(iif,'ena_seccams='+inttostr(ena_seccams));
    for b:=1 to 5 do
      writeln(iif,'cam_sc'+inttostr(b)+'='+cam_sc[b]);
    close(iif);
  except
    saveinifile:=false;
  end;
end;
