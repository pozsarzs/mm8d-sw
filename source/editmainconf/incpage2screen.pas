{ +--------------------------------------------------------------------------+ }
{ | MM8D v0.4 * Growing house and irrigation controlling and monitoring sys. | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incpage2screen.pas                                                       | }
{ | Show screen content of page #2                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// write options to screen
procedure page2screen;
var
  b: byte;
begin
  header(PRGNAME+' '+VERSION+' * Page 2/10: Enable/disable channels');
  textcolor(white);
  for b:=1 to 8 do
  begin
    gotoxy(4,b+2);
    write('Channel #'+inttostr(b)+':');
  end;
  for b:=1 to 8 do
  begin
    gotoxy(MINPOSX[2,1],b+2);
    writeln(ena_ch[b]);
  end;
end;
; +----------------------------------------------------------------------------+
; | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
; | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
; | mm8d.ini                                                                   |
; | Main settings                                                              |
; +----------------------------------------------------------------------------+

;
; software
;

[user]
; user's data
usr_nam=Szerafin Gomba Tiszaföldvár
usr_uid=00000000

[names]
; name of channels
nam_ch0=Irrigator
nam_ch1=Tent #11
nam_ch2=Tent #12
nam_ch3=(unused)
nam_ch4=(unused)
nam_ch5=(unused)
nam_ch6=(unused)
nam_ch7=(unused)
nam_ch8=(unused)

[enable]
; enable/disable channels (0/1)
ena_ch1=1
ena_ch2=1
ena_ch3=0
ena_ch4=0
ena_ch5=0
ena_ch6=0
ena_ch7=0
ena_ch8=0

[language]
; language of webpage (en/hu)
lng=en

[log]
; storing time of the log files
day_log=7
; create verbose debug log file
dbg_log=0
; number of log lines on web interface
web_lines=30

[directories]
; directories of program
dir_htm=/var/www/html
dir_lck=/var/local/lock
dir_log=/var/local/log
dir_msg=/usr/local/share/locale
dir_shr=/usr/local/share/mm8d
dir_tmp=/var/tmp
dir_var=/var/local/lib/mm8d

[openweathermap.org]
; access data
api_key=00000000000000000000000000000000
base_url=http://api.openweathermap.org/data/2.5/weather?
city_name=Tiszafoldvar

;
; hardware
;

[GPIOport]
; number of the used GPIO ports
prt_i1=12
prt_i2=16
prt_i3=20
prt_i4=21
prt_ro1=18
prt_ro2=23
prt_ro3=24
prt_ro4=25
prt_lo1=2
prt_lo2=3
prt_lo3=4
prt_lo4=17

[LPTport]
; address of the used LPT port (0x378: 0, 0x278: 1, 0x3BC: 2)
prt_lpt=0

[COMport]
; enable/disable external serial display (0/1)
ena_console=1
; port name
prt_com=/dev/ttyS0
; prt_com=/dev/ttyAMA0
; port speed
com_speed=9600
; level of verbosity of the log on console
; (nothing: 0, only error: 1, warning and error: 2, all: 3)
com_verbose=2

;
; external devices
;

[MM6D]
; protocol (http/modbus)
pro_mm6dch1=http
pro_mm6dch2=http
pro_mm6dch3=http
pro_mm6dch4=http
pro_mm6dch5=http
pro_mm6dch6=http
pro_mm6dch7=http
pro_mm6dch8=http
; IP address
adr_mm6dch1=192.168.1.11
adr_mm6dch2=192.168.1.12
adr_mm6dch3=192.168.1.13
adr_mm6dch4=192.168.1.14
adr_mm6dch5=192.168.1.15
adr_mm6dch6=192.168.1.16
adr_mm6dch7=192.168.1.17
adr_mm6dch8=192.168.1.18
; unitID
uid_mm6dch1=11
uid_mm6dch2=12
uid_mm6dch3=13
uid_mm6dch4=14
uid_mm6dch5=15
uid_mm6dch6=16
uid_mm6dch7=17
uid_mm6dch8=18

[MM7D]
; protocol (http/modbus)
pro_mm7dch1=http
pro_mm7dch2=http
pro_mm7dch3=http
pro_mm7dch4=http
pro_mm7dch5=http
pro_mm7dch6=http
pro_mm7dch7=http
pro_mm7dch8=http
; IP address
adr_mm7dch1=192.168.1.21
adr_mm7dch2=192.168.1.22
adr_mm7dch3=192.168.1.23
adr_mm7dch4=192.168.1.24
adr_mm7dch5=192.168.1.25
adr_mm7dch6=192.168.1.26
adr_mm7dch7=192.168.1.27
adr_mm7dch8=192.168.1.28
; unitID
uid_mm7dch1=21
uid_mm7dch2=22
uid_mm7dch3=23
uid_mm7dch4=24
uid_mm7dch5=25
uid_mm7dch6=26
uid_mm7dch7=27
uid_mm7dch8=28

[MM10D]
; enable/disable handling (0/1)
ena_mm10d=0
; protocol (http/modbus)
pro_mmd10=http
; IP address
adr_mm10d=192.168.1.30
; unitID
uid_mm10d=30

[IPcamera]
; show tent camera on the webpage of channel (0/1)
ena_cameras=0
; snapshot url of the tent cameras
cam_ch1=http://camera11.lan/snapshot.cgi?user=username&pwd=password
cam_ch2=http://camera12.lan/snapshot.cgi?user=username&pwd=password
cam_ch3=
cam_ch4=
cam_ch5=
cam_ch6=
cam_ch7=
cam_ch8=
; snapshot url of the security cameras
cam_sc1=http://camera01.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
cam_sc2=http://camera02.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
cam_sc3=http://camera03.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
cam_sc4=http://camera04.lan/webcapture.jpg?command=snap&channel=0&user=username&password=password
