{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
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

program editmainconf;
{$MODE OBJFPC}{$H+}
uses
  INIFiles, SysUtils, character, crt, untcommon;
var
  // general variables
  bottom:             byte;
  // configuration
  ch_enable:          array[1..8] of byte;
  ch_name:            array[0..8] of string;
  dir_htm:            string;
  dir_lck:            string;
  dir_log:            string;
  dir_msg:            string;
  dir_shr:            string;
  dir_tmp:            string;
  dir_var:            string;
  fwm_enable:         byte;
  fwm_handler:        string;
  fwm_modbusid:       integer;
  fwm_port:           string;
  fwm_speed:          longint;
  gpio_i:             array[1..5] of byte;
  gpio_lo:            array[1..4] of byte;
  gpio_ro:            array[1..8] of byte;
  ipcsec_enable:      byte;
  ipcsec_url:         array[1..4] of string;
  ipctent_enable:     byte;
  ipctent_url:        array[1..8] of string;
  lng:                string;
  log_day:            byte;
  log_debug:          byte;
  log_weblines:       byte;
  lpt_address:        integer;
  lpt_i_bit:          array[1..5] of integer;
  lpt_i_negation:     array[1..5] of integer;
  lpt_lo_bit:         array[1..4] of integer;
  lpt_lo_negation:    array[1..4] of integer;
  lpt_ro_bit:         array[1..8] of integer;
  lpt_ro_negation:    array[1..8] of integer;
  mm6d_intthermostat: byte;
  mm6d_port:          string;
  mm6d_protocol:      string;
  mm6d_speed:         longint;
  mm6dch_ipaddress:   array[1..8] of string;
  mm6dch_modbusid:    array[1..8] of integer;
  mm7d_port:          string;
  mm7d_protocol:      string;
  mm7d_speed:         longint;
  mm7dch_ipaddress:   array[1..8] of string;
  mm7dch_modbusid:    array[1..8] of integer;
  msc_enable:         byte;
  msc_port:           string;
  msc_speed:          longint;
  msc_verbose:        byte;
  otm_enable:         byte;
  otm_handler:        string;
  otm_modbusid:       integer;
  otm_port:           string;
  otm_speed:          longint;
  owm_apikey:         string;
  owm_city:           string;
  owm_enable:         byte;
  owm_url:            string;
  pwm_enable:         byte;
  pwm_handler:        string;
  pwm_modbusid:       integer;
  pwm_port:           string;
  pwm_speed:          longint;
  tdp_enable:         byte;
  tdp_handler:        string;
  tdp_port:           string;
  tdp_speed:          longint;
  tdpch_modbusid:     array[1..8] of integer;
  usr_name:           string;
const
  A:            string='language';
  C:            string='channels';
  D:            string='directories';
  F:            string='flowmeter';
  I:            string='localio';
  IPC:          string='ipcamera';
  L:            string='log';
  M6:           string='mm6d';
  M7:           string='mm7d';
  O:            string='openweathermap.org';
  P:            string='powermeter';
  S:            string='console';
  T:            string='outdoortempmeter';
  U:            string='user';
  Y:            string='tentdisplay';
  LASTPAGE:     byte=14;
  BLOCKS:       array[1..14] of byte=(1,1,1,1,1,1,1,3,3,4,2,3,3,4);
  MINPOSX:      array[1..14,1..6] of byte=((18,0,0,0,0,0),
                                           (17,0,0,0,0,0),
                                           (17,0,0,0,0,0),
                                           (15,0,0,0,0,0),
                                           (43,0,0,0,0,0),
                                           (23,0,0,0,0,0),
                                           (21,0,0,0,0,0),
                                           (15,15,15,0,0,0),
                                           (24,65,24,0,0,0),
                                           (22,22,62,62,0,0),
                                           (30,30,0,0,0,0),
                                           (31,31,31,0,0,0),
                                           (31,31,31,0,0,0),
                                           (17,36,17,36,0,0));
  MINPOSY:      array[1..14,1..6] of byte=((3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,0,0,0,0,0),
                                           (3,9,14,0,0,0),
                                           (4,4,22,0,0,0),
                                           (4,11,4,11,0,0),
                                           (3,12,0,0,0,0),
                                           (3,12,21,0,0,0),
                                           (3,12,21,0,0,0),
                                           (3,12,14,20,0,0));
  MAXPOSY:      array[1..14,1..6] of byte=((3,0,0,0,0,0),
                                           (11,0,0,0,0,0),
                                           (10,0,0,0,0,0),
                                           (4,0,0,0,0,0),
                                           (5,0,0,0,0,0),
                                           (9,0,0,0,0,0),
                                           (6,0,0,0,0,0),
                                           (7,12,21,0,0,0),
                                           (20,20,22,0,0,0),
                                           (7,15,8,15,0,0),
                                           (10,15,0,0,0,0),
                                           (10,19,24,0,0,0),
                                           (10,19,23,0,0,0),
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
{$I incpage13screen.pas}
{$I incpage14screen.pas}
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
    13: page13screen;
    14: page14screen;
  end;
  case page of
    4: footer(bottom-1,FOOTERS[6]);
    8: footer(bottom-1,FOOTERS[7]);
    9: footer(bottom-1,FOOTERS[7]);
    10: footer(bottom-1,FOOTERS[7]);
    11: footer(bottom-1,FOOTERS[7]);
    12: footer(bottom-1,FOOTERS[7]);
    13: footer(bottom-1,FOOTERS[7]);
    14: footer(bottom-1,FOOTERS[7]);
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
    {
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
    }
    // page #9 - block #2
    {
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
    }
    // page #9 - block #3
    {
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
    }
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
      // -- page #7 --
      7: begin
           if posy=3 then
           begin
             if (c='0') or (c='1') then s:=c;
             if c=#8 then delete(s,length(s),1);
           end else
           begin
             if (length(s)<50) and (c<>#0) and (c<>#8) and
               (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
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
            if block=1 then
            begin  
              case posy of
                4: begin
                     if (c='0') or (c='1') then s:=c;
                     if c=#8 then delete(s,length(s),1);
                   end;
                6: begin
                     if isnumber(c) then
                       if length(s)<6 then s:=s+c;
                     if c=#8 then delete(s,length(s),1);
                   end;
                7: begin
                     if isnumber(c) then
                       if length(s)<1 then s:=s+c;
                     if c=#8 then delete(s,length(s),1);
                   end;
              else
                begin
                  if (length(s)<50) and (c<>#0) and (c<>#8) and
                    (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
                  if c=#8 then delete(s,length(s),1);
                end;
              end;
            end else
            begin
              case posy of
                4: begin
                     if (c='0') or (c='1') then s:=c;
                     if c=#8 then delete(s,length(s),1);
                   end;
                6: begin
                     if isnumber(c) then
                       if length(s)<6 then s:=s+c;
                     if c=#8 then delete(s,length(s),1);
                   end;
                7: begin
                     if isnumber(c) then
                       if length(s)<3 then s:=s+c;
                     if c=#8 then delete(s,length(s),1);
                    end;
                11: begin
                      if (c='0') or (c='1') then s:=c;
                      if c=#8 then delete(s,length(s),1);
                    end;
                13: begin
                      if isnumber(c) then
                        if length(s)<6 then s:=s+c;
                      if c=#8 then delete(s,length(s),1);
                    end;
                14: begin
                      if isnumber(c) then
                        if length(s)<3 then s:=s+c;
                      if c=#8 then delete(s,length(s),1);
                    end;
              else
                begin
                  if (length(s)<50) and (c<>#0) and (c<>#8) and
                    (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
                  if c=#8 then delete(s,length(s),1);
                end;
              end;
            end;
          end;
      // -- page #11 --
      11: begin
           if block=1 then
           begin
             if isnumber(c) then
               if length(s)<3 then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
           if block=2 then
             case posy of
             12: begin
                   if (c='0') or (c='1') then s:=c;
                   if c=#8 then delete(s,length(s),1);
                 end;
             14: begin
                   if isnumber(c) then
                     if length(s)<6 then s:=s+c;
                   if c=#8 then delete(s,length(s),1);
                 end;
             else
             begin
               if (length(s)<50) and (c<>#0) and (c<>#8) and
                 (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
               if c=#8 then delete(s,length(s),1);
             end;
           end;
         end;
      // -- page #12 --
      12: begin
           if block=1 then
           begin
             if isnumber(c) then
               if length(s)<3 then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
           if block=2 then
           begin
             if (isnumber(c)) or (c='.') then
               if length(s)<15 then s:=s+c;
             if c=#8 then delete(s,length(s),1);
           end;
           if block=3 then
             case posy of
             23: begin
                   if isnumber(c) then
                     if length(s)<6 then s:=s+c;
                   if c=#8 then delete(s,length(s),1);
                 end;
             24: begin
                   if (c='0') or (c='1') then s:=c;
                   if c=#8 then delete(s,length(s),1);
                 end;
             else
             begin
               if (length(s)<50) and (c<>#0) and (c<>#8) and
                 (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
               if c=#8 then delete(s,length(s),1);
             end;
           end;
         end;
      // -- page #13 --
      13: begin
            if block=1 then
            begin
              if isnumber(c) then
                if length(s)<3 then s:=s+c;
               if c=#8 then delete(s,length(s),1);
            end;
            if block=2 then
            begin
              if (isnumber(c)) or (c='.') then
                if length(s)<15 then s:=s+c;
              if c=#8 then delete(s,length(s),1);
            end;
            if block=3 then
              if posy=23 then
              begin
                if isnumber(c) then
                  if length(s)<6 then s:=s+c;
                if c=#8 then delete(s,length(s),1);
              end else
              begin
                if (length(s)<50) and (c<>#0) and (c<>#8) and
                 (c<>#9) and (c<>#13) and (c<>#27) then s:=s+c;
               if c=#8 then delete(s,length(s),1);
             end;
         end;
      // -- page #14 --
      14: begin
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
          3: begin usr_name:=s; write(usr_name); end;
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
        ch_name[posy-3]:=s;
        write(ch_name[posy-3]);
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
        ch_enable[posy-2]:=strtoint(s);
        write(ch_enable[posy-2]);
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
          3: begin log_day:=strtoint(s); write(log_day); end;
          4: begin log_debug:=strtoint(s); write(log_debug); end;
          5: begin log_weblines:=strtoint(s); write(log_weblines); end;
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
          3: begin owm_enable:=strtoint(s); write(owm_enable); end;
          4: begin owm_apikey:=s; write(owm_apikey); end;
          5: begin owm_url:=s; write(owm_url); end;
          6: begin owm_city:=s; write(owm_city); end;
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
        gpio_i[posy-2]:=strtoint(s);
        write(gpio_i[posy-2]);
      end;
      // page #8 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        gpio_lo[posy-2-5]:=strtoint(s);
        write(gpio_lo[posy-2-5]);
      end;
      // page #8 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        gpio_ro[posy-2-10]:=strtoint(s);
        write(gpio_ro[posy-2-10]);
      end;
    end;
    // -- page #9 --
    if page=9 then
    begin
      // page #9 - block #1
      // page #9 - block #2
      // page #9 - block #3
    end;
    // -- page #10 --
    if page=10 then
    begin
      // page #10 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy);
        repeat write(' '); until wherex>38;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          4: begin msc_enable:=strtoint(s); write(msc_enable); end;
          5: begin msc_port:=s; write(msc_port); end;
          6: begin msc_speed:=strtoint(s); write(msc_speed); end;
          7: begin msc_verbose:=strtoint(s); write(msc_verbose); end;
        end;
      end;
      // page #10 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy);
        repeat write(' '); until wherex>38;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          11: begin pwm_enable:=strtoint(s); write(pwm_enable); end;
          12: begin pwm_port:=s; write(pwm_port); end;
          13: begin pwm_speed:=strtoint(s); write(pwm_speed); end;
          14: begin pwm_modbusid:=strtoint(s); write(pwm_modbusid); end;
          15: begin pwm_handler:=s; write(pwm_handler); end;
        end;
      end;
      // page #10 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy);clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          4: begin fwm_enable:=strtoint(s); write(fwm_enable); end;
          5: begin fwm_port:=s; write(fwm_port); end;
          6: begin fwm_speed:=strtoint(s); write(fwm_speed); end;
          7: begin fwm_handler:=s; write(fwm_handler); end;
        end;
      end;
      // page #10 - block #4
      if block=4 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          11: begin otm_enable:=strtoint(s); write(otm_enable); end;
          12: begin otm_port:=s; write(otm_port); end;
          13: begin otm_speed:=strtoint(s); write(otm_speed); end;
          14: begin otm_modbusid:=strtoint(s); write(otm_modbusid); end;
          15: begin otm_handler:=s; write(otm_handler); end;
        end;
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
        if strtoint(s) < 254 then
          tdpch_modbusid[posy-2-9]:=strtoint(s)
        else 
          tdpch_modbusid[posy-2-9]:=254;
        write(tdpch_modbusid[posy-2-9]);
      end;
      // page #11 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          12: begin tdp_enable:=strtoint(s); write(tdp_enable); end;
          13: begin tdp_port:=s; write(tdp_port); end;
          14: begin tdp_speed:=strtoint(s); write(tdp_speed); end;
          15: begin tdp_handler:=s; write(tdp_handler); end;
        end;
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
        if strtoint(s) < 254 then
          mm6dch_modbusid[posy-2-9]:=strtoint(s)
        else 
          mm6dch_modbusid[posy-2-9]:=254;
        write(mm6dch_modbusid[posy-2-9]);
      end;
      // page #12 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        mm6dch_ipaddress[posy-2-9]:=s;
        write(mm6dch_ipaddress[posy-2-9]);
      end;
      // page #12 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          21: begin mm6d_protocol:=s; write(mm6d_protocol); end;
          22: begin mm6d_port:=s; write(mm6d_port); end;
          23: begin mm6d_speed:=strtoint(s); write(mm6d_speed); end;
          24: begin mm6d_intthermostat:=strtoint(s); write(mm6d_intthermostat); end;
        end;
      end;
    end;
    // -- page #13 --
    if page=13 then
    begin
      // page #13 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        if strtoint(s) < 254 then
          mm7dch_modbusid[posy-2-9]:=strtoint(s)
        else 
          mm7dch_modbusid[posy-2-9]:=254;
        write(mm7dch_modbusid[posy-2-9]);
      end;
      // page #13 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        mm7dch_ipaddress[posy-2-9]:=s;
        write(mm7dch_ipaddress[posy-2-9]);
      end;
      // page #13 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        case posy of
          21: begin mm7d_protocol:=s; write(mm7d_protocol); end;
          22: begin mm7d_port:=s; write(mm7d_port); end;
          23: begin mm7d_speed:=strtoint(s); write(mm7d_speed); end;
        end;
      end;
    end;
    // -- page #14 --
    if page=14 then
    begin
      // page #14 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ipctent_url[posy-2]:=s;
        write(ipctent_url[posy-2]);
      end;
      // page #14 - block #2
      if block=2 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ipctent_enable:=strtoint(s);
        write(ipctent_enable);
      end;
      // page #14 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ipcsec_url[posy-13]:=s;
        write(ipcsec_url[posy-13]);
      end;
      // page #14 - block #4
      if block=4 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block],posy); clreol;
        gotoxy(MINPOSX[page,block],posy);
        ipcsec_enable:=strtoint(s);
        write(ipcsec_enable);
      end;
    end;
  end;
  case page of
     4: footer(bottom-1,FOOTERS[6]);
     8: footer(bottom-1,FOOTERS[7]);
    10: footer(bottom-1,FOOTERS[7]);
    11: footer(bottom-1,FOOTERS[7]);
    12: footer(bottom-1,FOOTERS[7]);
    14: footer(bottom-1,FOOTERS[7]);
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
    14: footer(bottom-1,FOOTERS[5]);
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
             if page>LASTPAGE then page:=LASTPAGE;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=LASTPAGE;
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
