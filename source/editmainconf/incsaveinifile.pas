{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incsaveinifile.pas                                                       | }
{ | Save configuration to ini file                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// save environment characteristics file
function saveinifile(filename: string): boolean;
var
  iif:     text;
  b:       byte;
const
  HEADER1: string='; +----------------------------------------------------------------------------+';
  HEADER2: string='; | MM8D v0.1 * Growing house controlling and remote monitoring device         |';
  HEADER3: string='; | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |';
  HEADER4: string='; | mm8d.ini                                                                   |';
  HEADER5: string='; | Main settings                                                              |';

begin
  saveinifile:=true;
  try
    assign(iif,filename);
    rewrite(iif);
    writeln(iif,HEADER1);
    writeln(iif,HEADER2);
    writeln(iif,HEADER3);
    writeln(iif,HEADER4);
    writeln(iif,HEADER5);
    writeln(iif,HEADER1);
    writeln(iif,'');
    writeln(iif,'['+U+']');
    writeln(iif,'; user''s data');
    writeln(iif,'usr_nam=',usr_nam);
    writeln(iif,'usr_uid=',usr_uid);
    for b:=1 to 3 do
      writeln(iif,'usr_dt'+inttostr(b)+'='+usr_dt[b]);
    writeln(iif,'');
    writeln(iif,'['+N+']');
    writeln(iif,'; name of channels');
    for b:=0 to 8 do
      writeln(iif,'nam_ch'+inttostr(b)+'='+nam_ch[b]);
    writeln(iif,'');
    writeln(iif,'['+E+']');
    writeln(iif,'; enable/disable channels');
    for b:=1 to 8 do
      writeln(iif,'ena_ch'+inttostr(b)+'='+inttostr(ena_ch[b]));
    writeln(iif,'');
    writeln(iif,'['+M6+']');
    writeln(iif,'; IP address of MM6D controllers');
    for b:=1 to 8 do
      writeln(iif,'adr_mm6dch'+inttostr(b)+'='+adr_mm6dch[b]);
    writeln(iif,'');
    writeln(iif,'['+M7+']');
    writeln(iif,'; IP address of MM7D controllers');
    for b:=1 to 8 do
      writeln(iif,'adr_mm7dch'+inttostr(b)+'='+adr_mm7dch[b]);
    writeln(iif,'');
    writeln(iif,'['+G+']');
    writeln(iif,'; number of used GPIO ports');
    for b:=0 to 7 do
      writeln(iif,'prt_in'+inttostr(b)+'='+inttostr(prt_in[b]));
    for b:=0 to 7 do
      writeln(iif,'prt_out'+inttostr(b)+'='+inttostr(prt_out[b]));
    writeln(iif,'');
    writeln(iif,'['+L+']');
    writeln(iif,'; address of used LPT port');
    writeln(iif,'; 0: 0x378');
    writeln(iif,'; 1: 0x278');
    writeln(iif,'; 2: 0x3BC');
    writeln(iif,'lpt_prt='+inttostr(lpt_prt));
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
    writeln(iif,'['+I+']');
    writeln(iif,'; camera of growing tents');
    writeln(iif,'; show camera picture on webpage');
    writeln(iif,'cam_show='+inttostr(cam_show));
    writeln(iif,'; jpg snapshot link of IP cameras');
    for b:=1 to 8 do
      writeln(iif,'cam_ch'+inttostr(b)+'='+cam_ch[b]);
    writeln(iif,'');
    writeln(iif,'['+A+']');
    writeln(iif,'; language of webpage (en/hu)');
    writeln(iif,'lng='+lng);
    writeln(iif,'');
    writeln(iif,'['+O+']');
    writeln(iif,'; create and show log');
    writeln(iif,'; storing time of log');
    writeln(iif,'day_log='+inttostr(day_log));
    writeln(iif,'; enable/disable verbose debug log');
    writeln(iif,'dbg_log='+inttostr(dbg_log));
    writeln(iif,'; number of log lines on web interface');
    writeln(iif,'web_lines='+inttostr(web_lines));
    close(iif);
  except
    saveinifile:=false;
  end;
end;
