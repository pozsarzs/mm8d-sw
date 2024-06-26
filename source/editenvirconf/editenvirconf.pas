{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.6 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | editenvirconf.pas                                                        | }
{ | Full-screen program for edit envir-ch?.ini file                          | }
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
//  12: bad terminal size
//  13: cannot write configuration file

program editenvirconf;
{$MODE OBJFPC}{$H+}
uses
  INIFiles, SysUtils, character, crt, untcommon;
var
  bottom:                             byte;
  gasconmax:                          byte;
  hheaterdis, mheaterdis:             array[0..23] of byte;
  hhummax, mhummax:                   byte;
  hhummin, mhummin:                   byte;
  hhumoff, mhumoff:                   byte;
  hhumon, mhumon:                     byte;
  hlightsoff1, mlightsoff1:           byte;
  hlightsoff2, mlightsoff2:           byte;
  hlightson1, mlightson1:             byte;
  hlightson2, mlightson2:             byte;
  htempmax, mtempmax:                 byte;
  htempmin, mtempmin:                 byte;
  htempoff, mtempoff:                 byte;
  htempon, mtempon:                   byte;
  hventdishightemp, mventdishightemp: array[0..23] of byte;
  hventdislowtemp, mventdislowtemp:   array[0..23] of byte;
  hventdis, mventdis:                 array[0..23] of byte;
  hventhightemp, mventhightemp:       shortint;
  hventlowtemp, mventlowtemp:         shortint;
  hventoff, mventoff:                 byte;
  hventon, mventon:                   byte;
const
  H:                                  string='hyphae';
  M:                                  string='mushroom';
  LASTPAGE:                           byte=10;
  FOOTERS:                            array[1..4] of string=(
                                        '<Tab>/<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                        '<Enter> accept  <Esc> cancel',
                                        '<+>/<-> sign change  <Enter> accept  <Esc> cancel',
                                        '<Esc> cancel');
  BLOCKS:                             array[1..10] of byte=(1,3,1,6,3,1,3,1,6,6);
  MINPOSX:                            array[1..10,1..6] of byte=((38,0,0,0,0,0),
                                                                 (38,18,38,0,0,0),
                                                                 (38,0,0,0,0,0),
                                                                 (38,18,38,58,78,38),
                                                                 (18,38,38,0,0,0),
                                                                 (38,0,0,0,0,0),
                                                                 (38,18,38,0,0,0),
                                                                 (38,0,0,0,0,0),
                                                                 (38,18,38,58,78,38),
                                                                 (18,38,38,0,0,0));
  MINPOSY:                            array[1..10,1..6] of byte=((3,0,0,0,0,0),
                                                                 (3,10,10,0,0,0),
                                                                 (3,0,0,0,0,0),
                                                                 (3,8,8,8,8,21),
                                                                 (4,4,17,0,0,0),
                                                                 (3,0,0,0,0,0),
                                                                 (3,10,10,0,0,0),
                                                                 (3,0,0,0,0,0),
                                                                 (3,8,8,8,8,21),
                                                                 (4,4,17,0,0,0));
  MAXPOSY:                           array[1..10,1..6] of byte=((6,0,0,0,0,0),
                                                                 (6,21,21,0,0,0),
                                                                 (6,0,0,0,0,0),
                                                                 (4,19,19,19,19,21),
                                                                 (15,15,17,0,0,0),
                                                                 (6,0,0,0,0,0),
                                                                 (6,21,21,0,0,0),
                                                                 (6,0,0,0,0,0),
                                                                 (4,19,19,19,19,21),
                                                                 (15,15,17,0,0,0));

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
      if (page=5) or (page=10) then
      begin
        case block of
          3: if length(s)<3 then s:=s+c;
        else if (c='0') or (c='1') then s:=c;
        end;
      end else
      begin
        case block of
          1: if length(s)<2 then s:=s+c;
          6: if length(s)<3 then s:=s+c;
        else if (c='0') or (c='1') then s:=c;
        end;
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
    // -- page #3 --
    if page=3 then
    begin
      // page #3 - block #1
      if block=1 then
      begin
        if strtoint(s)>23 then s:=inttostr(23);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hlightson1:=strtoint(s); write(hlightson1); end;
          4: begin hlightsoff1:=strtoint(s); write(hlightsoff1); end;
          5: begin hlightson2:=strtoint(s); write(hlightson2); end;
          6: begin hlightsoff2:=strtoint(s); write(hlightsoff2); end;
        end;
      end;
    end;
    // -- page #4 --
    if page=4 then
    begin
      // page #4 - block #1
      if block=1 then
      begin
        if strtoint(s)>59 then s:=inttostr(59);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hventon:=strtoint(s); write(hventon); end;
          4: begin hventoff:=strtoint(s); write(hventoff); end;
        end;
      end;
      // page #4 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdis[posy-8]:=strtoint(s);
        write(hventdis[posy-8]);
      end;
      // page #4 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdis[posy+4]:=strtoint(s);
        write(hventdis[posy+4]);
      end;
      // page #4 - block #4
      if block=4 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdislowtemp[posy-8]:=strtoint(s);
        write(hventdislowtemp[posy-8]);
      end;
      // page #4 - block #5
      if block=5 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdislowtemp[posy+4]:=strtoint(s);
        write(hventdislowtemp[posy+4]);
      end;
      // page #4 - block #6
      if block=6 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        hventlowtemp:=strtoint(s); write(hventlowtemp);
      end;
    end;
    // -- page #5 --
    if page=5 then
    begin
      // page #5 - block #1
      if block=1 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdishightemp[posy-4]:=strtoint(s);
        write(hventdishightemp[posy-4]);
      end;
      // page #5 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdishightemp[posy+8]:=strtoint(s);
        write(hventdishightemp[posy+8]);
      end;
      // page #5 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        hventhightemp:=strtoint(s); write(hventhightemp);
      end;
    end;
    // -- page #6 --
    if page=6 then
    begin
      // page #6 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mhummin:=strtoint(s); write(mhummin); end;
          4: begin mhumon:=strtoint(s); write(mhumon); end;
          5: begin mhumoff:=strtoint(s); write(mhumoff); end;
          6: begin mhummax:=strtoint(s); write(mhummax); end;
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
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mtempmin:=strtoint(s); write(mtempmin); end;
          4: begin mtempon:=strtoint(s); write(mtempon); end;
          5: begin mtempoff:=strtoint(s); write(mtempoff); end;
          6: begin mtempmax:=strtoint(s); write(mtempmax); end;
        end;
      end;
      // page #7 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mheaterdis[posy-10]:=strtoint(s);
        write(mheaterdis[posy-10]);
      end;
      // page #7 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mheaterdis[posy+2]:=strtoint(s);
        write(mheaterdis[posy+2]);
      end;
    end;
    // -- page #8 --
    if page=8 then
    begin
      // page #8 - block #1
      if block=1 then
      begin
        if strtoint(s)>23 then s:=inttostr(23);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mlightson1:=strtoint(s); write(mlightson1); end;
          4: begin mlightsoff1:=strtoint(s); write(mlightsoff1); end;
          5: begin mlightson2:=strtoint(s); write(mlightson2); end;
          6: begin mlightsoff2:=strtoint(s); write(mlightsoff2); end;
        end;
      end;
    end;
    // -- page #9 --
    if page=9 then
    begin
      // page #9 - block #1
      if block=1 then
      begin
        if strtoint(s)>59 then s:=inttostr(59);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mventon:=strtoint(s); write(mventon); end;
          4: begin mventoff:=strtoint(s); write(mventoff); end;
        end;
      end;
      // page #9 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdis[posy-8]:=strtoint(s);
        write(mventdis[posy-8]);
      end;
      // page #9 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdis[posy+4]:=strtoint(s);
        write(mventdis[posy+4]);
      end;
      // page #9 - block #4
      if block=4 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdislowtemp[posy-8]:=strtoint(s);
        write(mventdislowtemp[posy-8]);
      end;
      // page #9 - block #5
      if block=5 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdislowtemp[posy+4]:=strtoint(s);
        write(mventdislowtemp[posy+4]);
      end;
      // page #9 - block #6
      if block=6 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        mventlowtemp:=strtoint(s); write(mventlowtemp);
      end;
    end;
    // -- page #10 --
    if page=10 then
    begin
      // page #10 - block #1
      if block=1 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdishightemp[posy-8]:=strtoint(s);
        write(mventdishightemp[posy-8]);
      end;
      // page #10 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdishightemp[posy+4]:=strtoint(s);
        write(mventdishightemp[posy+4]);
      end;
      // page #10 - block #3
      if block=3 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        mventhightemp:=strtoint(s); write(mventhightemp);
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
             if page>10 then page:=10;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=10;
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
    quit(0,false,'Usage: '+paramstr(0)+' /path/envir.ini');
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
