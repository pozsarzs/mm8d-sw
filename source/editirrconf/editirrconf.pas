{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | editirrconf.pas                                                          | }
{ | Full-screen program for edit irrigation.ini file                         | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
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
  eveningstart, eveningstop:    array[1..3] of string;
  morningstart, morningstop:    array[1..3] of string;
  name:                         array[1..3] of string;
  rainafternoon, rainnight:     byte;
  tempday, tempmax, tempmin:    byte;
  workstart, workstop:          byte;
const
  C: string='common';
  T: string='tube-';
  BLOCKS:                       array[1..2] of byte=(1,3);
  MINPOSX:                      array[1..2,1..6] of byte=((76,0,0,0,0,0),
                                                          (40,40,40,0,0,0));
  MINPOSY:                      array[1..2,1..6] of byte=((3,0,0,0,0,0),
                                                          (3,10,17,0,0,0));
  MAXPOSY:                      array[1..2,1..6] of byte=((4,0,0,0,0,0),
                                                          (7,14,21,0,0,0));
  FOOTERS: array[1..3] of string=('<Tab>/<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                  '<Enter> accept  <Esc> cancel',
                                  '<Esc> cancel');

{$I config.pas}
{$I incpage01screen.pas}
{$I incpage02screen.pas}
{$I incloadinifile.pas}
{$I incsaveinifile.pas}

// base screen
procedure screen(page: byte);
begin
  background;
  case page of
    1: page01screen;
    2: page02screen;
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
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    if c=#8 then delete(s,length(s),1) else
    begin
      if (page=2) and ((posy=3) or (posy=10) or (posy=17)) then
      begin
        if (length(s)<32) and (c<>#0) and (c<>#8) and (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
      end else
      begin
        if (isnumber(c)) or (c=':') then
        begin
          if (page=1) and (block=1) then
            if length(s)<2 then s:=s+c;
          if page=2 then
            if length(s)<5 then s:=s+c;
        end;
      end;
    end;
    gotoxy(1,bottom); clreol; write('>'+s);
  until (c=#13) or (c=#27);
  textcolor(white);
  if (c=#13) and (length(s)>0) then
  begin
    // -- page #1 --
    textbackground(blue);
    if page=1 then
    begin
      // page #1 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin tempmin:=strtoint(s); write(tempmin); end;
          4: begin tempmax:=strtoint(s); write(tempmax); end;
        end;
      end;
    end;
    // -- page #2 --
    textbackground(blue);
    if page=2 then
    begin
      if (posy=3) or (posy=10) or (posy=17) then
      begin
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        posy:=posy-7*(block-1);
        case posy of
          3: begin name[block]:=s; write(name[block]); end;
        end;
      end else
      begin
        if length(s)=5 then 
          if s[3]=':' then
            if strtoint(s[1]+s[2])<24 then
             if strtoint(s[4]+s[5])<60 then
             begin
               gotoxy(MINPOSX[page,block],posy); write('     ');
               gotoxy(MINPOSX[page,block],posy);
               posy:=posy-7*(block-1);
               case posy of
                 3: begin name[block]:=s; write(name[block]); end;
                 4: begin morningstart[block]:=s; write(morningstart[block]); end;
                 5: begin morningstop[block]:=s; write(morningstop[block]); end;
                 6: begin eveningstart[block]:=s; write(eveningstart[block]); end;
                 7: begin eveningstop[block]:=s; write(eveningstop[block]); end;
               end;
             end;
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
  footer(bottom-1,FOOTERS[3]);
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
