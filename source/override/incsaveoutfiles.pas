{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.2 * Growing house controlling and remote monitoring device       | }
{ | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incsaveoutfiles.pas                                                      | }
{ | Save out files                                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// save output files
function saveoutfiles(directory: string): boolean;
var
  b:    byte;
  outf: text;

begin
  saveoutfiles:=true;
  for b:=1 to 3 do
  try
    assignfile(outf,directory+'out'+inttostr(b));
    rewrite(outf);
    writeln(outf,outputs[b]);
    closefile(outf);
  except
    saveoutfiles:=false;
  end;
end;
