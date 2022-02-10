{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.3 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | editirrconf.pas                                                          | }
{ | Full-screen program for edit irrigation.ini file                         | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// Exit codes:
//   0: normal exit, file is saved
//   1: cannot open configuration file
//   12: bad terminal size
//   13: cannot write configuration file

program editirrconf;
{$MODE OBJFPC}{$H+}
uses
  INIFiles, SysUtils, character, crt, untcommon;
var
  bottom:                       byte;
  eveningstart, eveningstop:    array[1..3] of integer;
  morningstart, morningstop:    array[1..3] of integer;
  name:                         array[1..3] of string;
  rainafternoon, rainnight:     byte;
  tempday, tempmax, tempmin:    byte;
  workstart, workstop:          byte;
const
  C: string='common';
  T: string='tube-';
  BLOCKS:                       array[1..2] of byte=(1,3);
  MINPOSX:                      array[1..2,1..6] of byte=((46,0,0,0,0,0),
                                                          (46,17,35,0,0,0));
  MINPOSY:                      array[1..2,1..6] of byte=((3,0,0,0,0,0),
                                                          (3,10,10,0,0,0));
  MAXPOSY:                      array[1..2,1..6] of byte=((6,0,0,0,0,0),
                                                          (6,21,21,0,0,0));
  FOOTERS: array[1..4] of string=('<Tab>/<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                  '<Enter> accept  <Esc> cancel',
                                  '<+>/<-> sign change  <Enter> accept  <Esc> cancel',
                                  '<Esc> cancel');

{$I config.pas}
{$I incpage1screen.pas}
{$I incpage2screen.pas}
{$I incloadinifile.pas}
{$I incsaveinifile.pas}

// draw base screen
procedure screen(page: byte);
begin
  background;
  case page of
    1: page1screen;
    2: page2screen;
  end;
  footer(bottom-1,FOOTERS[1]);
  textbackground(black);
  gotoxy(1,bottom); clreol;
end;

// get value from keyboard
procedure getvalue(page,block,posy: byte);
var
  c: char;
  s: string;
begin
  textbackground(black);
  footer(bottom-1,FOOTERS[2]);
  if block=6 then footer(bottom-1,FOOTERS[3]);
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    if (block=6) and (length(s)>0) then
      case c of
        '-': if strtoint(s)>0 then s:=inttostr(strtoint(s)*(-1));
        '+': if strtoint(s)<0 then s:=inttostr(strtoint(s)*(-1));
      end;
    if isnumber(c) then
      case block of
        1: if length(s)<2 then s:=s+c;
        6: if length(s)<3 then s:=s+c;
      else if (c='0') or (c='1') then s:=c;
      end;
    if c=#8 then delete(s,length(s),1);
    gotoxy(1,bottom); clreol; write('>'+s);
  until (c=#13) or (c=#27);
  textcolor(white);
  if (c=#13) and (length(s)>0) then
  begin
    // -- page #1 --
    if page=1 then
    begin
      // page #1 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hhummin:=strtoint(s); write(hhummin); end;
          4: begin hhumon:=strtoint(s); write(hhumon); end;
          5: begin hhumoff:=strtoint(s); write(hhumoff); end;
          6: begin hhummax:=strtoint(s); write(hhummax); end;
        end;
      end;
    end;
    // -- page #2 --
    if page=2 then
    begin
      // page #2 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy);write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin htempmin:=strtoint(s); write(htempmin); end;
          4: begin htempon:=strtoint(s); write(htempon); end;
          5: begin htempoff:=strtoint(s); write(htempoff); end;
          6: begin htempmax:=strtoint(s); write(htempmax); end;
        end;
      end;
      // page #2 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hheaterdis[posy-10]:=strtoint(s);
        write(hheaterdis[posy-10]);
      end;
      // page #2 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hheaterdis[posy+2]:=strtoint(s);
        write(hheaterdis[posy+2]);
      end;
    end;
  end;
  footer(bottom-1,FOOTERS[1]);
  gotoxy(1,bottom); clreol;
end;

// set value
function setvalues: boolean;
var
  page, block, posy: byte;
  k : char;
label back;
begin
  page:=1;
  block:=1;
  screen(page);
 back:
  textbackground(black);
  gotoxy(1,bottom); clreol;
  footer(bottom-1,FOOTERS[1]);
  posy:=MINPOSY[page,block];
  gotoxy(MINPOSX[page,block],posy);
  repeat
    k:=readkey;
    if k=#0 then k:=readkey;
    case k of
      // first page
      #71: begin
             page:=1;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // previous page
      #73: begin
             page:=page-1;
             if page<1 then page:=1;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // next page
      #81: begin
             page:=page+1;
             if page>2 then page:=2;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=2;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
       // next block on page
       #9: begin
             block:=block+1;
             if block>BLOCKS[page] then block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
       // previous item in block
       #72: begin
             posy:=posy-1;
             if posy<MINPOSY[page,block] then posy:=MAXPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
            end;
       // next item in block
       #80: begin
             posy:=posy+1;
             if posy>MAXPOSY[page,block] then posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
            end;
       // select and edit item
       #13: begin
              getvalue(page,block,posy);
              gotoxy(MINPOSX[page,block],posy);
            end;
        end;
  // exit
  until k=#27;
  footer(bottom-1,FOOTERS[4]);
  textcolor(lightgray);
  gotoxy(1,bottom); write('Save to '+paramstr(1)+'? (y/n) ');
  textcolor(white);
  repeat
    k:=lowercase(readkey);
    if k=#27 then goto back;
  until (k='y') or (k='n');
  if k='y' then setvalues:=true else setvalues:=false;
end;

begin
  textcolor(lightgray); textbackground(black);
  if paramcount=0
  then
    quit(0,false,'Usage: '+paramstr(0)+' /path/irrigation.ini');
  if not terminalsize
  then
    quit(12,false,'ERROR #12: Minimal terminal size is 80x25!');
    bottom:=screenheight;
  if not loadinifile(paramstr(1))
  then
    quit(1,false,'ERROR #1: Cannot open '+paramstr(1)+' configuration file!');
  if not setvalues
  then
    quit(0,true,'Warning: File '+paramstr(1)+' is not saved.');
  if not saveinifile(paramstr(1))
  then
    quit(13,true,'ERROR #13: Cannot write '+paramstr(1)+' configuration file!');
  quit(0,true,'');
end.
