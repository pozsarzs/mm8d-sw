{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | override.pas                                                             | }
{ | Full-screen program for override output status                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// Exit codes:
//   0: normal exit, files are saved
//   8: cannot write output files
//  12: wrong terminal size

program ovrride;
{$MODE OBJFPC}{$H+}
uses
  SysUtils, character, crt, untcommon;
var
  bottom:  byte;
  outputs: array[1..4] of string;
const
  MAXPOSY: byte=5;
  MINPOSX: byte=30;
  MINPOSY: byte=3;
  STATUS:  array[0..2] of string=('off','on','neutral');
  FOOTERS: array[1..3] of string=('<Up>/<Down> move  <Enter> edit  <Esc> exit',
                                  '<F1> off  <F2> on  <F3> neutral  <Enter> accept  <Esc> cancel',
                                  '<Esc> cancel');
{$I config.pas}
{$I incloadoutfiles.pas}
{$I incpage1screen.pas}
{$I incsaveoutfiles.pas}

// draw base screen
procedure screen;
begin
  background;
  page1screen(paramstr(1));
  footer(bottom-1,FOOTERS[1]);
  textbackground(black);
  gotoxy(1,bottom); clreol;
end;

// get value from keyboard
procedure getvalue(posy: byte);
var
  c: char;
  s: string;
begin
  textbackground(black);
  footer(bottom-1,FOOTERS[2]);
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    case c of
      #59: s:=STATUS[0];
      #60: s:=STATUS[1];
      #61: s:=STATUS[2];
    end;
    if c=#8 then s:='';
    gotoxy(1,bottom); clreol; write('>'+s);
  until (c=#13) or (c=#27);
  textcolor(white);
  if (c=#13) and (length(s)>0) then
  begin
    textbackground(blue);
    gotoxy(MINPOSX,posy); write('       ');
    gotoxy(MINPOSX,posy);
    outputs[posy-2]:=s;
    write(outputs[posy-2]);
  end;
  footer(bottom-1,FOOTERS[1]);
  gotoxy(1,bottom); clreol;
end;

// set value
function setvalues: boolean;
var
  posy: byte;
  k : char;
label back;
begin
  screen;
 back:
  textbackground(black);
  gotoxy(1,bottom); clreol;
  footer(bottom-1,FOOTERS[1]);
  posy:=MINPOSY;
  gotoxy(MINPOSX,posy);
  repeat
    k:=readkey;
    if k=#0 then k:=readkey;
    case k of
       // previous item in block
       #72: begin
              posy:=posy-1;
              if posy<MINPOSY then posy:=MAXPOSY;
              gotoxy(MINPOSX,posy);
            end;
       // next item in block
       #80: begin
              posy:=posy+1;
              if posy>MAXPOSY then posy:=MINPOSY;
              gotoxy(MINPOSX,posy);
            end;
       // select and edit item
       #13: begin
              getvalue(posy);
              gotoxy(MINPOSX,posy);
            end;
        end;
  // exit
  until k=#27;
  footer(bottom-1,FOOTERS[3]);
  textcolor(lightgray); gotoxy(1,bottom); write('Save output files? (y/n) ');
  textcolor(white);
  repeat
    k:=lowercase(readkey);
    if k=#27 then goto back;
  until (k='y') or (k='n');
  if k='y'then setvalues:=true else setvalues:=false;
end;

begin
  textcolor(lightgray); textbackground(black);
  if paramcount=0
  then
    quit(0,false,'Usage: '+paramstr(0)+' /path_of_out_files/');
  if not terminalsize
  then
    quit(12,false,'ERROR #12: Minimal terminal size is 80x25!')
  else
    bottom:=screenheight;
  loadoutfiles(paramstr(1));
  if not setvalues
  then
    quit(0,true,'Warning: Files are not saved.');
  if not saveoutfiles(paramstr(1))
  then
    quit(8,true,'ERROR #8: Cannot write output files!');
  quit(0,true,'');
end.
