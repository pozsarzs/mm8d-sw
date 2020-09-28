{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.1 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>          | }
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
  iif: text;
  b: byte;
const
  HEADER1='; +----------------------------------------------------------------------------+';
  HEADER2='; | MM8D v0.1 * Growing house controlling and remote monitoring device         |';
  HEADER3='; | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |';
  HEADER4='; | envir-ch??.ini                                                             |';
  HEADER5='; | Growing environment characteristics                                        |';
  H: string='hyphae';
  M: string='mushroom';

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
    writeln(iif,'['+H+']');
    writeln(iif,'; humidifier');
    writeln(iif,'humidity_min=',hhummin);
    writeln(iif,'humidifier_on=',hhumon);
    writeln(iif,'humidifier_off=',hhumoff);
    writeln(iif,'humidity_max=',hhummax);
    writeln(iif,'');
    writeln(iif,'; heaters');
    writeln(iif,'temperature_min=',htempmin);
    writeln(iif,'heater_on=',htempon);
    writeln(iif,'heater_off=',htempoff);
    writeln(iif,'temperature_max=',htempmax);
    for b:=0 to 9 do
      writeln(iif,'heater_disable_0'+inttostr(b)+'=',hheaterdis[b]);
    for b:=10 to 23 do
      writeln(iif,'heater_disable_'+inttostr(b)+'=',hheaterdis[b]);
    writeln(iif,'');
    writeln(iif,'; lights');
    writeln(iif,'light_on1=',hlightson1);
    writeln(iif,'light_off1=',hlightsoff1);
    writeln(iif,'light_on2=',hlightson2);
    writeln(iif,'light_off2=',hlightsoff2);
    writeln(iif,'');
    writeln(iif,'; ventillators');
    writeln(iif,'vent_on=',hventon);
    writeln(iif,'vent_off=',hventoff);
    for b:=0 to 9 do
      writeln(iif,'vent_disable_0'+inttostr(b)+'=',hventdis[b]);
    for b:=10 to 23 do
      writeln(iif,'vent_disable_'+inttostr(b)+'=',hventdis[b]);
    for b:=0 to 9 do
      writeln(iif,'vent_disablelowtemp_0'+inttostr(b)+'=',hventdislowtemp[b]);
    for b:=10 to 23 do
      writeln(iif,'vent_disablelowtemp_'+inttostr(b)+'=',hventdislowtemp[b]);
    writeln(iif,'vent_lowtemp=',hventlowtemp);
    writeln(iif,'');
    writeln(iif,'['+M+']');
    writeln(iif,'; humidifier');
    writeln(iif,'humidity_min=',mhummin);
    writeln(iif,'humidifier_on=',mhumon);
    writeln(iif,'humidifier_off=',mhumoff);
    writeln(iif,'humidity_max=',mhummax);
    writeln(iif,'');
    writeln(iif,'; heaters');
    writeln(iif,'temperature_min=',mtempmin);
    writeln(iif,'heater_on=',mtempon);
    writeln(iif,'heater_off=',mtempoff);
    writeln(iif,'temperature_max=',mtempmax);
    for b:=0 to 9 do
      writeln(iif,'heater_disable_0'+inttostr(b)+'=',mheaterdis[b]);
    for b:=10 to 23 do
      writeln(iif,'heater_disable_'+inttostr(b)+'=',mheaterdis[b]);
    writeln(iif,'');
    writeln(iif,'; lights');
    writeln(iif,'light_on1=',mlightson1);
    writeln(iif,'light_off1=',mlightsoff1);
    writeln(iif,'light_on2=',mlightson2);
    writeln(iif,'light_off2=',mlightsoff2);
    writeln(iif,'');
    writeln(iif,'; ventillators');
    writeln(iif,'vent_on=',mventon);
    writeln(iif,'vent_off=',mventoff);
    for b:=0 to 9 do
      writeln(iif,'vent_disable_0'+inttostr(b)+'=',mventdis[b]);
    for b:=10 to 23 do
      writeln(iif,'vent_disable_'+inttostr(b)+'=',mventdis[b]);
    for b:=0 to 9 do
      writeln(iif,'vent_disablelowtemp_0'+inttostr(b)+'=',mventdislowtemp[b]);
    for b:=10 to 23 do
      writeln(iif,'vent_disablelowtemp_'+inttostr(b)+'=',mventdislowtemp[b]);
    writeln(iif,'vent_lowtemp=',mventlowtemp);
    writeln(iif,'');
    close(iif);
  except
    saveinifile:=false;
  end;
end;
