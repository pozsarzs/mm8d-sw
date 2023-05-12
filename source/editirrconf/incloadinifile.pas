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
    tempmin:=strtoint(iif.ReadString(C,'temp_min','0'));
    tempmax:=strtoint(iif.ReadString(C,'temp_max','0'));
    for b:=1 to 3 do
    begin
      name[b]:=iif.ReadString(T+inttostr(b),'name','Irrigator tube #'+inttostr(b));
      morningstart[b]:=iif.ReadString(T+inttostr(b),'morning_start','00:00');
      morningstop[b]:=iif.ReadString(T+inttostr(b),'morning_stop','00:00');
      eveningstart[b]:=iif.ReadString(T+inttostr(b),'evening_start','00:00');
      eveningstop[b]:=iif.ReadString(T+inttostr(b),'evening_stop','00:00');
    end;
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
