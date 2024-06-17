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
    writeln(iif,'; common parameters');
    writeln(iif,'temp_min=',tempmin);
    writeln(iif,'temp_max=',tempmax);
    for b:=1 to 3 do
    begin
      writeln(iif,'');
      writeln(iif,'['+T+inttostr(b)+']');
      writeln(iif,'; parameters of tube');
      writeln(iif,'name=',name[b]);
      writeln(iif,'enable=',enable[b]);
      writeln(iif,'morning_start=',morningstart[b]);
      writeln(iif,'morning_stop=',morningstop[b]);
      writeln(iif,'evening_start=',eveningstart[b]);
      writeln(iif,'evening_stop=',eveningstop[b]);
    end;
    close(iif);
  except
    saveinifile:=false;
  end;
end;
