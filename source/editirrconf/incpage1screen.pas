{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage1screen.pas                                                       | }
{ | Show screen content of page #1                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page1screen;
var
  b: byte;
  x: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 1/2: Common parameters');
  textcolor(white);
  gotoxy(4,3); writeln('Start month of work:');
  gotoxy(4,4); writeln('End month of work:');
  gotoxy(4,5); writeln('Maximal temperature (above this, irrigation is missed):');
  gotoxy(4,6); writeln('Minimal temperature (below this, irrigation is missed):');
  gotoxy(4,7); writeln('Daytime average temp. (below this, evening irrigation is missed):');
  gotoxy(4,8); writeln('All time of afternoon rainfall:');
  gotoxy(4,9); writeln('All time of night rainfall:');
  x:=75;
  if workstart>9 then gotoxy(x,3) else gotoxy(x+1,3); writeln(workstart,' m');
  if workstop>9 then gotoxy(x,4) else gotoxy(x+1,4); writeln(workstop,' m');
  if tempmin>9 then gotoxy(x,5) else gotoxy(x+1,5); writeln(tempmin,' °C');
  if tempmax>9 then gotoxy(x,6) else gotoxy(x+1,6); writeln(tempmax,' °C');
  if tempday>9 then gotoxy(x,7) else gotoxy(x+1,7); writeln(tempday,' °C');
  if rainafternoon>9 then gotoxy(x,8) else gotoxy(x+1,8); writeln(rainafternoon,' h');
  if rainnight>9 then gotoxy(x,9) else gotoxy(x+1,9); writeln(rainnight,' h');
end;
