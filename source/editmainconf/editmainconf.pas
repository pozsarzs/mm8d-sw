{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.5 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | editmainconf.pas                                                         | }
{ | Full-screen program for edit mm8d.ini file                               | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.2 version.
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
  bottom:       byte;
  // configuration
  adr_mm10d:    string;
  adr_mm6dch:   array[1..8] of string;
  adr_mm7dch:   array[1..8] of string;
  api_key:      string;
  base_url:     string;
  cam_ch:       array[1..8] of string;
  cam_sc:       array[1..5] of string;
  city_name:    string;
  com_speed:    string;
  com_verbose:  byte;
  day_log:      byte;
  dbg_log:      byte;
  dir_htm:      string;
  dir_lck:      string;
  dir_log:      string;
  dir_msg:      string;
  dir_shr:      string;
  dir_tmp:      string;
  dir_var:      string;
  ena_tentcams: byte;
  ena_seccams:  byte;
  ena_ch:       array[1..8] of byte;
  ena_console:  byte;
  ena_mm10d:    byte;
  lng:          string;
  nam_ch:       array[0..8] of string;
  pro_mm6dch:   array[1..8] of string;
  pro_mm7dch:   array[1..8] of string;
  pro_mm10d:    string;
  prt_com:      string;
  prt_i:        array[1..4] of byte;
  prt_lo:       array[1..4] of byte;
  prt_lpt:      byte;
  prt_ro:       array[1..4] of byte;
  uid_mm10d:    string;
  uid_mm6dch:   array[1..8] of string;
  uid_mm7dch:   array[1..8] of string;
  usr_nam:      string;
  usr_uid:      string;
  web_lines:    byte;
const
  A:            string='language';
  C:            string='COMport';
  D:            string='directories';
  E:            string='enable';
  G:            string='GPIOport';
  I:            string='IPcamera';
  L:            string='LPTport';
  M10:          string='MM10D';
  M6:           string='MM6D';
  M7:           string='MM7D';
  N:            string='names';
  O:            string='log';
  U:            string='user';
  W:            string='openweathermap.org';
  BLOCKS:       array[1..12] of byte=(1,1,2,1,1,1,1,5,3,3,3,4);
  MINPOSX:      array[1..12,1..6] of byte=((18,0,0,0,0,0),
                                           (17,0,0,0,0,0),
                                           (17,17,0,0,0,0),
                                           (15,0,0,0,0,0),
                                           (43,0,0,0,0,0),
                                           (31,0,0,0,0,0),
                                           (19,0,0,0,0,0),
                                           (15,15,15,26,28,0),
                                           (25,25,25,0,0,0),
                                           (25,25,25,0,0,0),
                                           (25,25,25,0,0,0),
                                           (37,37,37,37,0,0));
  MINPOSY:      array[1..12,1..6] of byte=((3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,12,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,8,13,18,23,0),
                                           (3,12,21,0,0,0),
                                           (3,12,21,0,0,0),
                                           (3,12,21,0,0,0),
                                           (3,12,14,20,0,0));
  MAXPOSY:      array[1..12,1..6] of byte=((4,0,0,0,0,0),
                                           (11,0,0,0,0,0),
                                           (10,12,0,0,0,0),
                                           (4,0,0,0,0,0),
                                           (5,0,0,0,0,0),
                                           (9,0,0,0,0,0),
                                           (5,0,0,0,0,0),
                                           (6,11,16,18,26,0),
                                           (10,19,21,0,0,0),
                                           (10,19,21,0,0,0),
                                           (10,19,21,0,0,0),
                                           (10,12,18,20,0,0));
  FOOTERS:      array[1..7] of string=('<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                       '<Enter> accept  <Esc> cancel',
                                       '<Space> change <Tab>/<Up>/<Down> move  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                       '<Esc> cancel',
                                       '<Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                       '<Space> select  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                       '<Tab>/<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit');
  CODE:         array[3..4] of string=('en','hu');
  PROTOCOL:     array[1..2] of string=('http','modbus');

{$I config.pas}
{$I incpage01screen.pas}
{$I incpage02screen.pas}
{$I incpage03screen.pas}
{$I incpage04screen.pas}
{$I incpage05screen.pas}
{$I incpage06screen.pas}
{$I incpage07screen.pas}
{$I incpage08screen.pas}
{$I incpage09screen.pas}
{$I incpage10screen.pas}
{$I incpage11screen.pas}
{$I incpage12screen.pas}
{$I incloadinifile.pas}
{$I incsaveinifile.pas}

// draw base screen
procedure screen(page: byte);
begin
  background;
  case page of
    1: page01screen;
    2: page02screen;
    3: page03screen;
    4: page04screen;
    5: page05screen;
    6: page06screen;
    7: page07screen;
    8: page08screen;
    9: page09screen;
    10: page10screen;
    11: page11screen;
    12: page12screen;
  end;
  case page of
    4: footer(bottom-1,FOOTERS[6]);
    8: footer(bottom-1,FOOTERS[7]);
    9: footer(bottom-1,FOOTERS[3]);
    10: footer(bottom-1,FOOTERS[7]);
    11: footer(bottom-1,FOOTERS[7]);
    12: footer(bottom-1,FOOTERS[7]);
    else footer(bottom-1,FOOTERS[1]);
  end;
  textbackground(black);
  gotoxy(1,bottom); clreol;
end;

// select one from all
procedure selectitem(page,block,posy: byte);
var
  b: byte;
begin
  // -- page #4 --
  if page=4 then
  begin
    // page #4 - block #1
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
  // -- page #9 --
  if page=9 then
  begin
    // page #9 - block #1
    if block=1 then
    begin
      if pro_mm6dch[posy-2]=PROTOCOL[1]
      then
        pro_mm6dch[posy-2]:=PROTOCOL[2]
      else
        pro_mm6dch[posy-2]:=PROTOCOL[1];
      textbackground(blue);
      gotoxy(MINPOSX[page,block],posy); clreol;
      gotoxy(MINPOSX[page,block],posy);
      write(pro_mm6dch[posy-2]);
    end;
    // page #9 - block #2
    if block=2 then
    begin
      if pro_mm7dch[posy-2-9]=PROTOCOL[1]
      then
        pro_mm7dch[posy-2-9]:=PROTOCOL[2]
      else
        pro_mm7dch[posy-2-9]:=PROTOCOL[1];
      textbackground(blue);
      gotoxy(MINPOSX[page,block],posy); clreol;
      gotoxy(MINPOSX[page,block],posy);
      write(pro_mm7dch[posy-2-9]);
    end;
    // page #9 - block #3
    if block=3 then
    begin
      if pro_mm10d=PROTOCOL[1]
      then
        pro_mm10d:=PROTOCOL[2]
      else
        pro_mm10d:=PROTOCOL[1];
      textbackground(blue);
      gotoxy(MINPOSX[page,block],posy); clreol;
      gotoxy(MINPOSX[page,block],posy);
      write(pro_mm10d);
    end;
  end;
end;

// get value from keyboard
procedure getvalue(page,block,posy: byte);
var
  c: char;
  s: string;
begin
  textbackground(black);
  case page of
    9: footer(bottom-1,FOOTERS[3]);
  else footer(bottom-1,FOOTERS[2]);
  end;
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    case page of
      // -- page #3 --
      3: begin
           if (c='0') or (c='1') then s:=c;
           if c=#8 then delete(s,length(s),1);
         end;
      // -- page #5 --
      5: begin
           if posy=4 then
           begin
             if (c='0') or (c='1') then s:=c;
             if c=#8 then delete(s,length(s),1);
           end else
           begin
             if isnumber(c) then
               if length(s)<2 then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
         end;
      // -- page #8 --
      8: begin
           if (block<4) then
           begin
             if isnumber(c) then
               if length(s)<2 then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
           if (block=4) then
           begin
             if posy=18 then
             begin
               if (c='1') or (c='2') or (c='3') then s:=c;
               if c=#8 then delete(s,length(s),1);
             end else
             begin
               if isnumber(c) then
                 if length(s)<2 then s:=s+c;
               if c=#8 then delete(s,length(s),1);
             end;
           end;
           if (block=5) then
           begin
             if posy=23 then
             begin
               if (c='0') or (c='1') then s:=c;
               if c=#8 then delete(s,length(s),1);
             end;
             if (posy>23) and (posy<26) then
             begin
               if (length(s)<50) and (c<>#0) and (c<>#8) and
                 (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
               if c=#8 then delete(s,length(s),1);
             end;
             if posy=26 then
             begin
               if (c='0') or (c='1') or (c='2') or (c='3') then s:=c;
               if c=#8 then delete(s,length(s),1);
             end;
           end;
         end;
     // -- page #9 --
      9: begin
         end;
     // -- page #10 --
     10: begin
           if isnumber(c) then
             if length(s)<3 then s:=s+c;
           if c=#8 then delete(s,length(s),1);
         end;
     // -- page #11 --
     11: begin
           if (isnumber(c)) or (c='.') then
             if length(s)<15 then s:=s+c;
           if c=#8 then delete(s,length(s),1);
         end;
     // -- page #12 --
     12: begin
           if (block=1) or (block=3) then
           begin
            if (length(s)<50) and (c<>#0) and (c<>#8) and
             (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
           if (block=2) or (block=4) then
           begin
             if (c='0') or (c='1') then s:=c;
             if c=#8 then delete(s,length(s),1);
           end;
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
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        nam_ch[posy-3]:=s;
        write(nam_ch[posy-3]);
      end;
    end;
    // -- page #3 --
    if page=3 then
    begin
      // page #3 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ena_ch[posy-2]:=strtoint(s);
        write(ena_ch[posy-2]);
      end;
      // page #3 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ena_mm10d:=strtoint(s);
        write(ena_mm10d);
      end;
    end;
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
          3: begin day_log:=strtoint(s); write(day_log); end;
          4: begin dbg_log:=strtoint(s); write(dbg_log); end;
          5: begin web_lines:=strtoint(s); write(web_lines); end;
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
    // -- page #7 --
    if page=7 then
    begin
      // page #7 - block #1
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
        prt_i[posy-2]:=strtoint(s);
        write(prt_i[posy-2]);
      end;
      // page #8 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        prt_ro[posy-2-5]:=strtoint(s);
        write(prt_ro[posy-2-5]);
      end;
      // page #8 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        prt_lo[posy-2-10]:=strtoint(s);
        write(prt_lo[posy-2-10]);
      end;
      // page #8 - block #4
      if block=4 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        prt_lpt:=strtoint(s);
        write(prt_lpt);
      end;
    end;
      // page #8 - block #5
      if block=5 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          23: begin ena_console:=strtoint(s); write(ena_console); end;
          24: begin prt_com:=s; write(prt_com); end;
          25: begin com_speed:=s; write(com_speed); end;
          26: begin com_verbose:=strtoint(s); write(com_verbose); end;
        end;
      end;
    // -- page #9 --
    if page=9 then
    begin
      // page #9 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        pro_mm6dch[posy-2]:=s;
        write(pro_mm6dch[posy-2]);
      end;
      // page #9 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        pro_mm7dch[posy-2-9]:=s;
        write(pro_mm7dch[posy-2-9]);
      end;
      // page #9 - block #2
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        pro_mm10d:=s;
        write(pro_mm10d);
      end;
    end;
    // -- page #10 --
    if page=10 then
    begin
      // page #10 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        uid_mm6dch[posy-2]:=s;
        write(uid_mm6dch[posy-2]);
      end;
      // page #10 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        uid_mm7dch[posy-2-9]:=s;
        write(uid_mm7dch[posy-2-9]);
      end;
      // page #10 - block #2
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        uid_mm10d:=s;
        write(uid_mm10d);
      end;
    end;
    // -- page #11 --
    if page=11 then
    begin
      // page #11 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        adr_mm6dch[posy-2]:=s;
        write(adr_mm6dch[posy-2]);
      end;
      // page #11 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        adr_mm7dch[posy-2-9]:=s;
        write(adr_mm7dch[posy-2-9]);
      end;
      // page #11 - block #2
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        adr_mm10d:=s;
        write(adr_mm10d);
      end;
    end;
    // -- page #12 --
    if page=12 then
    begin
      // page #12 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        cam_ch[posy-2]:=s;
        write(cam_ch[posy-2]);
      end;
      // page #12 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ena_tentcams:=strtoint(s);
        write(ena_tentcams);
      end;
      // page #12 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        cam_sc[posy-13]:=s;
        write(cam_sc[posy-13]);
      end;
      // page #12 - block #4
      if block=4 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ena_seccams:=strtoint(s);
        write(ena_seccams);
      end;
    end;
  end;
  case page of
     4: footer(bottom-1,FOOTERS[6]);
     8: footer(bottom-1,FOOTERS[7]);
    10: footer(bottom-1,FOOTERS[7]);
    11: footer(bottom-1,FOOTERS[7]);
    12: footer(bottom-1,FOOTERS[7]);
  else footer(bottom-1,FOOTERS[1]);
  end;
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
  case page of
    6: footer(bottom-1,FOOTERS[6]);
    9: footer(bottom-1,FOOTERS[3]);
    10: footer(bottom-1,FOOTERS[5]);
    11: footer(bottom-1,FOOTERS[5]);
    12: footer(bottom-1,FOOTERS[5]);
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
             if page>12 then page:=12;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=12;
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
       #13: if (page<>4) and (page<>9) then
            begin
              getvalue(page,block,posy);
              gotoxy(MINPOSX[page,block],posy);
            end;
       // select item
       #32: begin
              if (page=4) then
              begin
                selectitem(page,block,posy);
                gotoxy(MINPOSX[page,block],posy);
              end;
              if (page=9) then
              begin
                selectitem(page,block,posy);
                gotoxy(MINPOSX[page,block],posy);
              end;
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
  loadinifile(paramstr(1));
  if not loadinifile(paramstr(1))
    then quit(3,false,'ERROR #1: Cannot open '+paramstr(1)+' configuration file!');
  if not setvalues
    then quit(0,true,'File '+paramstr(1)+' is not saved.');
  if not saveinifile(paramstr(1))
    then quit(13,true,'ERROR #13: Cannot write '+paramstr(1)+' configuration file!');
  quit(0,true,'');
end.
