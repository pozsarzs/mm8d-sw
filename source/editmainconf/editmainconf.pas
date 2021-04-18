{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.2 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | editmainconf.pas                                                         | }
{ | Full-screen program for edit mm5d.ini file                               | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// Exit codes:
//   0: normal exit
//   1: cannot open configuration file
//  12: minimal terminal size is 80x25!
//  13: cannot write configuration file

{$DEFINE USRLOCALDIR}

program editmainconf;
{$MODE OBJFPC}{$H+}
uses
  INIFiles, SysUtils, character, crt, untcommon;
var
  // general variables
  bottom: byte;
  // configuration
  adr_mm6dch: array[1..8] of string;
  adr_mm7dch: array[1..8] of string;
  api_key:    string;
  base_url:   string;
  cam_ch:     array[1..8] of string;
  cam_show:   byte;
  city_name:  string;
  day_log:    byte;
  dbg_log:    byte;
  dir_htm:    string;
  dir_lck:    string;
  dir_log:    string;
  dir_msg:    string;
  dir_shr:    string;
  dir_tmp:    string;
  dir_var:    string;
  ena_ch:     array[1..8] of byte;
  lng:        string;
  lpt_prt:    byte;
  nam_ch:     array[0..8] of string;
  prt_in:     array[1..8] of byte;
  prt_out:    array[1..8] of byte;
  usr_dt:     array[1..3] of string;
  usr_nam:    string;
  usr_uid:    string;
  web_lines:  byte;
const
  VERSION:    string='v0.1';
  PRGNAME:    string='MM8D-EditMainConf';
  D:          string='directories';
  E:          string='enable';
  G:          string='GPIOports';
  L:          string='LPTport';
  M6:         string='MM6D';
  M7:         string='MM7D';
  N:          string='names';
  U:          string='user';
  W:          string='openweathermap.org';
  I:          string='IPcameras';
  A:          string='language';
  O:          string='log';
  BLOCKS:     array[1..9] of byte=(1,1,1,1,1,1,1,1,2);
  MINPOSX:    array[1..9,1..6] of byte=((30,0,0,0,0,0),
                                        (26,0,0,0,0,0),
                                        (26,0,0,0,0,0),
                                        (26,0,0,0,0,0),
                                        (36,0,0,0,0,0),
                                        (26,0,0,0,0,0),
                                        (16,0,0,0,0,0),
                                        (46,0,0,0,0,0),
                                        (46,12,0,0,0,0));
  MINPOSY:    array[1..9,1..6] of byte=((3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (3,7,0,0,0,0));
  MAXPOSY:    array[1..9,1..6] of byte=((7,0,0,0,0,0),
                                        (14,0,0,0,0,0),
                                        (20,0,0,0,0,0),
                                        (3,0,0,0,0,0),
                                        (9,0,0,0,0,0),
                                        (5,0,0,0,0,0),
                                        (4,0,0,0,0,0),
                                        (5,0,0,0,0,0),
                                        (5,8,0,0,0,0));
  FOOTERS:    array[1..7] of string=('<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                     '<Enter> accept  <Esc> cancel',
                                     '',
                                     '<Esc> cancel',
                                     '<Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                     '<Space> select  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                     '<Tab>/<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit');
  CODE:       array[3..4] of string=('en','hu');

{$I incpage1screen.pas}
{$ I incpage2screen.pas}
{$ I incpage3screen.pas}
{$ I incpage4screen.pas}
{$I incpage5screen.pas}
{$I incpage6screen.pas}
{$I incpage7screen.pas}
{$I incpage8screen.pas}
{$ I incpage9screen.pas}
{$I incloadinifile.pas}
{$I incsaveinifile.pas}

procedure screen(page: byte);
begin
  background;
  case page of
    1: page1screen;
//    2: page2screen;
//    3: page3screen;
//    4: page4screen;
    5: page5screen;
    6: page6screen;
    7: page7screen;
    8: page8screen;
//    9: page9screen;
  end;
  case page of
//    4: footer(bottom-1,FOOTERS[5]);
    7: footer(bottom-1,FOOTERS[6]);
//    9: footer(bottom-1,FOOTERS[7]);
    else footer(bottom-1,FOOTERS[1]);
  end;
  textbackground(black);
  gotoxy(1,bottom); clreol;
end;

procedure selectitem(page,block,posy: byte);
var
  b: byte;
begin
  // -- page #7 --
  if page=7 then
  begin
    // page #7 - block #1
    if block=1 then
    begin
        textbackground(blue);
        for b:=3 to MAXPOSY[page,block] do
        begin
          gotoxy(MINPOSX[page,block],b); write('  ');
        end;
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        write('<<');
        lng:=code[posy];
    end;
  end;
end;

procedure getvalue(page,block,posy: byte);
var
  c: char;
  s: string;
begin
  textbackground(black);
  case page of
    4: footer(bottom-1,FOOTERS[3]);
  else footer(bottom-1,FOOTERS[2]);
  end;
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    case page of
      3: begin
           if isnumber(c) then
             if length(s)<2 then s:=s+c;
           if c=#8 then delete(s,length(s),1);
         end;
      4: case c of
           #59: s:='AM2302';
           #60: s:='DHT11';
           #61: s:='DHT22';
         end;
      8: begin
           if isnumber(c) then
             if length(s)<2 then s:=s+c;
           if c=#8 then delete(s,length(s),1);
         end;
      9: begin
           case block of
             1: if (c='0') or (c='1') then s:=c;
             2: s:=s+c;
           end;
           if c=#8 then delete(s,length(s),1);
         end;
    else
      begin
        if (length(s)<50) and (c<>#0) and (c<>#8) and
          (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
        if c=#8 then delete(s,length(s),1);
      end;
    end;
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
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          3: begin usr_nam:=s; write(usr_nam); end;
          4: begin usr_uid:=s; write(usr_uid); end;
          5: begin usr_dt[1]:=s; write(usr_dt[1]); end;
          6: begin usr_dt[2]:=s; write(usr_dt[2]); end;
          7: begin usr_dt[3]:=s; write(usr_dt[3]); end;
        end;
      end;
    end;
{    // -- page #2 --
    if page=2 then
    begin
      // page #2 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
           3: begin nam_in[1]:=s; write(nam_in[1]); end;
           4: begin nam_in[2]:=s; write(nam_in[2]); end;
           5: begin nam_in[3]:=s; write(nam_in[3]); end;
           6: begin nam_in[4]:=s; write(nam_in[4]); end;
           7: begin nam_out[1]:=s; write(nam_out[1]); end;
           8: begin nam_out[2]:=s; write(nam_out[2]); end;
           9: begin nam_out[3]:=s; write(nam_out[3]); end;
          10: begin nam_out[4]:=s; write(nam_out[4]); end;
          11: begin nam_err[1]:=s; write(nam_err[1]); end;
          12: begin nam_err[2]:=s; write(nam_err[2]); end;
          13: begin nam_err[3]:=s; write(nam_err[3]); end;
          14: begin nam_err[4]:=s; write(nam_err[4]); end;
        end;
      end;
    end;
    // -- page #3 --
    if page=3 then
    begin
      // page #3 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]+4,posy); clreol;
        gotoxy(MINPOSX[page,block]+4,posy);
        case posy of
            3: begin prt_in[1]:=strtoint(s); write(prt_in[1]); end;
            4: begin prt_in[2]:=strtoint(s); write(prt_in[2]); end;
            5: begin prt_in[3]:=strtoint(s); write(prt_in[3]); end;
            6: begin prt_in[4]:=strtoint(s); write(prt_in[4]); end;
            7: begin prt_out[1]:=strtoint(s); write(prt_out[1]); end;
            8: begin prt_out[2]:=strtoint(s); write(prt_out[2]); end;
            9: begin prt_out[3]:=strtoint(s); write(prt_out[3]); end;
           10: begin prt_out[4]:=strtoint(s); write(prt_out[4]); end;
           11: begin prt_err[1]:=strtoint(s); write(prt_err[1]); end;
           12: begin prt_err[2]:=strtoint(s); write(prt_err[2]); end;
           13: begin prt_err[3]:=strtoint(s); write(prt_err[3]); end;
           14: begin prt_err[4]:=strtoint(s); write(prt_err[4]); end;
           15: begin prt_sensor:=strtoint(s); write(prt_sensor); end;
           16: begin prt_switch:=strtoint(s); write(prt_switch); end;
           17: begin prt_act:=strtoint(s); write(prt_act); end;
           18: begin prt_twrgreen:=strtoint(s); write(prt_twrgreen); end;
           19: begin prt_twrred:=strtoint(s); write(prt_twrred); end;
           20: begin prt_twryellow:=strtoint(s); write(prt_twryellow); end;
        end;
      end;
    end;
    // -- page #4 --
    if page=4 then
    begin
      // page #4 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        sensor_type:=s; write(sensor_type);
      end;
    end;}
    // -- page #5 --
    if page=5 then
    begin
      // page #5 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          3: begin dir_htm:=s; write(dir_htm); end;
          4: begin dir_lck:=s; write(dir_lck); end;
          5: begin dir_log:=s; write(dir_log); end;
          6: begin dir_msg:=s; write(dir_msg); end;
          7: begin dir_shr:=s; write(dir_shr); end;
          8: begin dir_tmp:=s; write(dir_tmp); end;
          9: begin dir_var:=s; write(dir_var); end;
        end;
      end;
    end;
    // -- page #6 --
    if page=6 then
    begin
      // page #6 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          3: begin api_key:=s; write(api_key); end;
          4: begin base_url:=s; write(base_url); end;
          5: begin city_name:=s; write(city_name); end;
        end;
      end;
    end;
    // -- page #8 --
    if page=8 then
    begin
      // page #8 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          3: begin day_log:=strtoint(s); write(day_log); end;
          4: begin dbg_log:=strtoint(s); write(dbg_log); end;
          5: begin web_lines:=strtoint(s); write(web_lines); end;
        end;
      end;
    end;
{    // -- page #9 --
    if page=9 then
    begin
      // page #9 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          3: begin cam_show:=strtoint(s); write(cam_show); end;
          4: begin cam1_enable:=strtoint(s); write(cam1_enable); end;
          5: begin cam2_enable:=strtoint(s); write(cam2_enable); end;
        end;
      end;
      // page #9 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          7: begin cam1_jpglink:=s; write(cam1_jpglink); end;
          8: begin cam2_jpglink:=s; write(cam2_jpglink); end;
        end;
      end;
    end;}
  end;
  case page of
    4: footer(bottom-1,FOOTERS[5]);
    7: footer(bottom-1,FOOTERS[6]);
    else footer(bottom-1,FOOTERS[1]);
  end;
  gotoxy(1,bottom); clreol;
end;

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
  case page of
    4: footer(bottom-1,FOOTERS[5]);
    7: footer(bottom-1,FOOTERS[6]);
    else footer(bottom-1,FOOTERS[1]);
  end;
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
             if page>9 then page:=9;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=9;
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
       #13: if (page<>7) then
            begin
              getvalue(page,block,posy);
              gotoxy(MINPOSX[page,block],posy);
            end;
       // select item
       #32: if (page=7) then
            begin
              selectitem(page,block,posy);
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

function terminalsize: boolean;
begin
  if (screenwidth>=80) and (screenheight>=25)
    then terminalsize:=true
    else terminalsize:=false;
  bottom:=screenheight;
end;

begin
  textcolor(lightgray); textbackground(black);
  if paramcount=0 then
    quit(0,false,'Usage:'+#10+'    '+paramstr(0)+' /path/mm8d.ini');
  if not terminalsize
    then quit(12,false,'ERROR #12: Minimal terminal size is 80x25!');
  if not loadinifile(paramstr(1))
    then quit(3,false,'ERROR #1: Cannot open '+paramstr(1)+' configuration file!');
  if not setvalues
    then quit(0,true,'File '+paramstr(1)+' is not saved.');
  if not saveinifile(paramstr(1))
    then quit(13,true,'ERROR #13: Cannot write '+paramstr(1)+' configuration file!');
  quit(0,true,'');
end.
