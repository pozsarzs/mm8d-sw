{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
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
    writeln(iif,fullline('MM8D '+VERSION+' * Growing house and irrigation controlling and remote monitoring system'));
    writeln(iif,fullline(COPYRIGHT));
    writeln(iif,fullline('irrigator.ini'));
    writeln(iif,fullline('Irrigator settings'));
    writeln(iif,l);
    writeln(iif,'');
  end;

begin
  saveinifile:=true;
  try
    assign(iif,filename);
    rewrite(iif);
    fileheader;
    writeln(iif,'['+C+']');
    writeln(iif,'');
    writeln(iif,'; start month of work');
    writeln(iif,'work_start=',workstart);
    writeln(iif,'; end month of work');
    writeln(iif,'work_stop=',workstop);
    writeln(iif,'; minimal temperature (below this value, irrigation is missed)');
    writeln(iif,'temp_min=',tempmin);
    writeln(iif,'; maximal temperature (above this value, irrigation is missed)');
    writeln(iif,'temp_max=',tempmax);
    writeln(iif,'; daytime average temperature (below this value, evening irrigation is missed)');
    writeln(iif,'temp_day=',tempday);
    writeln(iif,'; all time of night rainfall');
    writeln(iif,'rain_night=',rainnight);
    writeln(iif,'; all time of afternoon rainfall');
    writeln(iif,'rain_afternoon=',rainafternoon);

    for b:=1 to 3 do
    begin
      writeln(iif,'');
      writeln(iif,'['+T+inttorstr(b)+']');
      writeln(iif,'; name of tube');
      writeln(iif,'name=',name[b]);
      writeln(iif,'; morning irrigation interval');
      writeln(iif,'morning_start=',morning_start[b]);
      writeln(iif,'morning_stop=',morning_stop[b]);
      writeln(iif,'; evening irrigation interval');
      writeln(iif,'evening_start=',evening_start[b]);
      writeln(iif,'evening_stop=',evening_stop[b]);
    end;
    close(iif);
  except
    saveinifile:=false;
  end;
end;
