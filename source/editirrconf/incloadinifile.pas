{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
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
    workstart:=strtoint(iif.ReadString(C,'work_start','0'));
    workstop:=strtoint(iif.ReadString(C,'work_stop','0'));
    tempmin:=strtoint(iif.ReadString(C,'temp_min','0'));
    tempmax:=strtoint(iif.ReadString(C,'temp_max','0'));
    tempday:=strtoint(iif.ReadString(C,'temp_day','0'));
    rainnight:=strtoint(iif.ReadString(C,'rain_night','0'));
    rainafternoon:=strtoint(iif.ReadString(C,'rain_afternoon','0'));
    for b:=1 to 3 do
    begin
      name:=iif.ReadString(T+inttostr(b),'name','Irrigator tube #'+inttostr(b));
      morningstart:=strtoint(iif.ReadString(T+inttostr(b),'morning_start','0'));
      morningstop:=strtoint(iif.ReadString(T+inttostr(b),'morning_stop','0'));
      eveningstar:=strtoint(iif.ReadString(T+inttostr(b),'evening_start','0'));
      eveningstop:=strtoint(iif.ReadString(T+inttostr(b),'evening_stop','0'));
    end;
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
