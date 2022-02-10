{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incloadoutfiles.pas                                                      | }
{ | Load out files                                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// load output files
procedure loadoutfiles(directory: string);
var
  b, bb: byte;
  outf:  text;
  s:     string;

begin
  for b:=1 to 3 do
  try
    outputs[b]:=STATUS[2];
    assignfile(outf,directory+'/out'+inttostr(b));
    reset(outf);
    readln(outf,s);
    for bb:=0 to 1 do
      if s=STATUS[bb] then outputs[b]:=STATUS[bb];
    closefile(outf);
  except
  end;
end;
