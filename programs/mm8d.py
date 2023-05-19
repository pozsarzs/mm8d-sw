#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | mm8d.py                                                                    |
# | Main program                                                               |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit
#   1: cannot open configuration file
#  14: cannot open environment characteristic configuration file
#  15: cannot create log file
#  17: cannot access i/o port
#  18: there is not enabled channel
#  19: fatal error
#  20: cannot open irrigator configuration file

import configparser
import daemon
import io
import json
import os
import platform
import requests
import serial
import sys
import time
from time import localtime, strftime

arch=platform.machine()
if arch.find("86") > -1:
  hw = 1
  import portio
else:
  hw = 0
  import RPi.GPIO as GPIO

USRLOCALDIR = 1
if USRLOCALDIR == 1:
  confdir='/usr/local/etc/mm8d/'
else:
  confdir='/etc/mm8d/'

COMPMV6=0
COMPSV6=3
COMPMV7=0
COMPSV7=3
COMPMV10=0
COMPSV10=1
DELAY=2

global eol
global lptaddresses
eol = "\r"
lptaddresses = [0x378,0x278,0x3bc]

# add a zero char
def addzero(num):
  if num < 10:
    z = "0"
  else:
    z = ""
  s = z + str(num)
  return s

# write a line to debug logfile
def writetodebuglog(level,text):
  if level == "i":
    if com_verbose > 2:
      writedebuglogtocomport(level,text)
  if level == "w":
    if com_verbose > 1:
      writedebuglogtocomport(level,text)
  if level == "e":
    if com_verbose > 0:
      writedebuglogtocomport(level,text)
  if dbg_log == "1":
    if level == "i":
      lv = "INFO   "
    if level == "w":
      lv = "WARNING"
    if level == "e":
      lv = "ERROR  "
    debugfile = dir_log + '/' + time.strftime("debug-%Y%m%d.log")
    dt = (strftime("%Y-%m-%d %H:%M:%S",localtime()))
    try:
      with open(debugfile,"a") as d:
        d.write(dt + '  ' + lv + ' ' + text + '\n')
        d.close()
    except:
      print ("")

# write a debug log line to serial port
def writedebuglogtocomport(level,text):
  if ena_console == "1":
    dt = (strftime("%y%m%d %H%M%S",localtime()))
    try:
      com.open
      com.write(str.encode(dt + ' ' + str.upper(level) + ' ' + text + eol))
      com.close
      time.sleep(0.1)
    except:
      print("COM!")

# send power supply data to display via serial port
def writepowersupplydatatocomport():
  # transmitbuffer = [0x00 for x in range(13)]
  line = ""
  if ena_console == "1":
    # !!! !!!
    try:
      com.open
      com.write(str.encode(line))
      com.close
      time.sleep(0.1)
    except:
      print("")

# send channels' data to display via serial port
def writechannelstatustocomport(channel):
  transmitbuffer = [0x00 for x in range(13)]
  line = ""
  if ena_console == "1":
    if channel == 0:
      transmitbuffer[0x00] = ord("C")
      transmitbuffer[0x01] = ord("H")
      transmitbuffer[0x02] = channel
      transmitbuffer[0x03] = mainsbreakers
      transmitbuffer[0x04] = waterpressurelow
      transmitbuffer[0x05] = waterpressurehigh
      if exttemp > 0:
        transmitbuffer[0x06] = exttemp
      else:
        transmitbuffer[0x06] = 0x00
      transmitbuffer[0x07] = relay_tube1
      transmitbuffer[0x08] = relay_tube2
      transmitbuffer[0x09] = relay_tube3
      transmitbuffer[0x0A] = 0x00
      transmitbuffer[0x0B] = 0x00
      transmitbuffer[0x0C] = 0x00
      if override[channel][1] == "on":
        transmitbuffer[0x07] = 0x03
      if override[channel][1] == "off":
        transmitbuffer[0x07] = 0x02
      if override[channel][2] == "on":
        transmitbuffer[0x08] = 0x03
      if override[channel][2] == "off":
        transmitbuffer[0x08] = 0x02
      if override[channel][3] == "on":
        transmitbuffer[0x09] = 0x03
      if override[channel][3] == "off":
        transmitbuffer[0x09] = 0x02
    else:
      transmitbuffer[0x00] = ord("C")
      transmitbuffer[0x01] = ord("H")
      transmitbuffer[0x02] = channel
      transmitbuffer[0x03] = in_temperature[channel]
      transmitbuffer[0x04] = in_humidity[channel]
      transmitbuffer[0x05] = in_gasconcentrate[channel]
      transmitbuffer[0x06] = not in_opmode[channel]
      transmitbuffer[0x07] = in_swmanu[channel]
      transmitbuffer[0x08] = in_ocprot[channel]
      transmitbuffer[0x09] = in_alarm[channel]
      transmitbuffer[0x0A] = out_lamps[channel]
      transmitbuffer[0x0B] = out_vents[channel]
      transmitbuffer[0x0C] = out_heaters[channel]
      if override[channel][1] == "on":
        transmitbuffer[0x0A] = 0x03
      if override[channel][1] == "off":
        transmitbuffer[0x0A] = 0x02
      if override[channel][2] == "on":
        transmitbuffer[0x0B] = 0x03
      if override[channel][2] == "off":
        transmitbuffer[0x0B] = 0x02
      if override[channel][3] == "on":
        transmitbuffer[0x0C] = 0x03
      if override[channel][3] == "off":
        transmitbuffer[0x0C] = 0x02
      if ena_ch[channel] == 0:
        transmitbuffer[0x06] = 0x7F
    for x in range(0,13):
      line = line + chr(transmitbuffer[x])
    try:
      com.open
      com.write(str.encode(line))
      com.close
      time.sleep(0.1)
    except:
      print("")

# load configuration
def loadconfiguration(conffile):
  global adr_mm10d
  global adr_mm6dch
  global adr_mm7dch
  global api_key
  global base_url
  global city_name
  global com_speed
  global com_verbose
  global dbg_log
  global dir_log
  global dir_var
  global ena_ch
  global ena_console
  global ena_mmd10
  global lockfile
  global logfile
  global pro_mm10d
  global pro_mm6dch
  global pro_mm7dch
  global prt_com
  global uid_mm10d
  global uid_mm6dch
  global uid_mm7dch
  global usr_uid
  if (hw == 0):
    global prt_i1
    global prt_i2
    global prt_i3
    global prt_i4
    global prt_ro1
    global prt_ro2
    global prt_ro3
    global prt_ro4
    global prt_lo1
    global prt_lo2
    global prt_lo3
    global prt_lo4
  else:
    global prt_lpt
  C = 'COMport'
  D = 'directories'
  E = 'enable'
  G = 'GPIOport'
  L = 'log'
  LP = 'LPTport'
  M10 = 'MM10D'
  M6 = 'MM6D'
  M7 = 'MM7D'
  O = 'openweathermap.org'
  U = 'user'
  global HP
  HP = 'http'
  try:
    with open(conffile) as f:
      mainconfig = f.read()
    config = configparser.RawConfigParser(allow_no_value = True)
    config.read_file(io.StringIO(mainconfig))
    # user's data
    usr_uid = config.get(U,'usr_uid')
    # enable/disable channels (0/1)
    ena_ch = [0 for x in range(9)]
    for i in range(1,9):
      ena_ch[i] = int(config.get(E,'ena_ch' + str(i)))
    # create verbose debug log file
    dbg_log = '0'
    dbg_log = config.get(L,'dbg_log')
    # directories of program
    dir_log = config.get(D,'dir_log')
    dir_var = config.get(D,'dir_var')
    lockfile = config.get(D,'dir_lck') + 'mm8d.lck'
    # access data
    api_key = config.get(O,'api_key')
    base_url = config.get(O,'base_url')
    city_name = config.get(O,'city_name')
    # number of the used GPIO ports
    if hw == 0:
      prt_i1 = int(config.get(G,'prt_i1'))
      prt_i2 = int(config.get(G,'prt_i2'))
      prt_i3 = int(config.get(G,'prt_i3'))
      prt_i4 = int(config.get(G,'prt_i4'))
      prt_ro1 = int(config.get(G,'prt_ro1'))
      prt_ro2 = int(config.get(G,'prt_ro2'))
      prt_ro3 = int(config.get(G,'prt_ro3'))
      prt_ro4 = int(config.get(G,'prt_ro4'))
      prt_lo1 = int(config.get(G,'prt_lo1'))
      prt_lo2 = int(config.get(G,'prt_lo2'))
      prt_lo3 = int(config.get(G,'prt_lo3'))
      prt_lo4 = int(config.get(G,'prt_lo4'))
    else:
      # address of the used LPT port (0x378: 0, 0x278: 1, 0x3BC: 2)
      prt_lpt = int(config.get(LP,'prt_lpt'))
    # enable/disable external serial display (0/1)
    ena_console = '0'
    ena_console = config.get(C,'ena_console')
    # port name
    prt_com = '/dev/ttyS0'
    prt_com = config.get(C,'prt_com')
    # port speed
    com_speed = '9600'
    com_speed = config.get(C,'com_speed')
    # level of verbosity of the log on console
    com_verbose = 0
    com_verbose = int(config.get(C,'com_verbose'))
    # protocol (http/modbus)
    pro_mm6dch = [HP for x in range(9)]
    pro_mm7dch = [HP for x in range(9)]
    # IP address
    adr_mm6dch = [0 for x in range(9)]
    adr_mm7dch = [0 for x in range(9)]
    # ModBUS unitID
    uid_mm6dch = [0 for x in range(9)]
    uid_mm7dch = [0 for x in range(9)]
    for i in range(1,9):
      # protocol (http/modbus)
      pro_mm6dch[i] = config.get(M6,'pro_mm6dch' + str(i))
      pro_mm7dch[i] = config.get(M7,'pro_mm7dch' + str(i))
      adr_mm6dch[i] = config.get(M6,'adr_mm6dch' + str(i))
      adr_mm7dch[i] = config.get(M7,'adr_mm7dch' + str(i))
      ena_ch[i] = int(config.get(E,'ena_ch' + str(i)))
      uid_mm6dch[i] = config.get(M6,'uid_mm6dch' + str(i))
      uid_mm7dch[i] = config.get(M7,'uid_mm7dch' + str(i))
    # enable/disable handling (0/1)
    ena_mm10d = '0'
    ena_mm10d = int(config.get(M10,'ena_mmd10'))
    # protocol (http/modbus)
    pro_mm10d = HP
    pro_mm10d = config.get(M10,'pro_mm10d')
    # IP address
    adr_mm10d = 0
    adr_mm10d = config.get(M10,'adr_mm10d')
    # ModBUS unitID
    uid_mm10d = 0
    uid_mm10d = config.get(M10,'uid_mm10d')
    writetodebuglog("i","Configuration is loaded.")
  except:
    writetodebuglog("e","ERROR #01: Cannot open " + conffile + "!")
    exit(1)

# load configuration
def loadirrconf(conffile):
  C = "common"
  T = "tube-"
  global irevening_start
  global irevening_stop
  global irmorning_start
  global irmorning_stop
  global irtemp_max
  global irtemp_min
  irevening_start = [0 for channel in range(4)]
  irevening_stop = [0 for channel in range(4)]
  irmorning_start = [0 for channel in range(4)]
  irmorning_stop = [0 for channel in range(4)]
  irtemp_max = 0
  irtemp_min = 0
  try:
    with open(conffile) as f:
      mainconfig = f.read()
    config = configparser.RawConfigParser(allow_no_value = True)
    config.read_file(io.StringIO(mainconfig))
    irtemp_max = int(config.get(C,'temp_max'))
    irtemp_min = int(config.get(C,'temp_min'))
    for i in range(1,4):
      irevening_start[i] = config.get(T + str(i),'evening_start')
      irevening_stop[i] = config.get(T + str(i),'evening_stop')
      irmorning_start[i] = config.get(T + str(i),'morning_start')
      irmorning_stop[i] = config.get(T + str(i),'morning_stop')
    writetodebuglog("i","Irrigator configuration is loaded.")
  except:
    writetodebuglog("e","ERROR #20: Cannot open " + conffile + "!")
    exit(20)

# load environment characteristics
def loadenvirconf(channel,conffile):
  C = "common"
  H = "hyphae"
  M = "mushroom"
  try:
    with open(conffile) as f:
      envir_config = f.read()
    config = configparser.RawConfigParser(allow_no_value = True)
    config.read_file(io.StringIO(envir_config))
    cgasconcentrate_max[channel] = int(config.get(C,'gasconcentrate_max'))
    hhumidifier_off[channel] = int(config.get(H,'humidifier_off'))
    hhumidity_max[channel] = int(config.get(H,'humidity_max'))
    hhumidity_min[channel] = int(config.get(H,'humidity_min'))
    hhumidifier_on[channel] = int(config.get(H,'humidifier_on'))
    htemperature_max[channel] = int(config.get(H,'temperature_max'))
    hheater_off[channel] = int(config.get(H,'heater_off'))
    hheater_on[channel] = int(config.get(H,'heater_on'))
    htemperature_min[channel] = int(config.get(H,'temperature_min'))
    for x in range(24):
      hheater_disable[x][channel] = int(config.get(H,'heater_disable_' + addzero(x)))
    hlight_on1[channel] = int(config.get(H,'light_on1'))
    hlight_off1[channel] = int(config.get(H,'light_off1'))
    hlight_on2[channel] = int(config.get(H,'light_on2'))
    hlight_off2[channel] = int(config.get(H,'light_off2'))
    hvent_on[channel] = int(config.get(H,'vent_on'))
    hvent_off[channel] = int(config.get(H,'vent_off'))
    for x in range(24):
      hvent_disable[x][channel] = int(config.get(H,'vent_disable_' + addzero(x)))
    for x in range(24):
      hvent_disablelowtemp[x][channel] = int(config.get(H,'vent_disablelowtemp_' + addzero(x)))
    hvent_lowtemp[channel] = int(config.get(H,'vent_lowtemp'))
    for x in range(24):
      hvent_disablehightemp[x][channel] = int(config.get(H,'vent_disablehightemp_' + addzero(x)))
    hvent_hightemp[channel] = int(config.get(H,'vent_hightemp'))
    mhumidifier_off[channel] = int(config.get(M,'humidifier_off'))
    mhumidity_max[channel] = int(config.get(M,'humidity_max'))
    mhumidity_min[channel] = int(config.get(M,'humidity_min'))
    mhumidifier_on[channel] = int(config.get(M,'humidifier_on'))
    mtemperature_max[channel] = int(config.get(M,'temperature_max'))
    mheater_off[channel] = int(config.get(M,'heater_off'))
    mheater_on[channel] = int(config.get(M,'heater_on'))
    mtemperature_min[channel] = int(config.get(M,'temperature_min'))
    for x in range(24):
      mheater_disable[x][channel] = int(config.get(M,'heater_disable_' + addzero(x)))
    mlight_on1[channel] = int(config.get(M,'light_on1'))
    mlight_off1[channel] = int(config.get(M,'light_off1'))
    mlight_on2[channel] = int(config.get(M,'light_on2'))
    mlight_off2[channel] = int(config.get(M,'light_off2'))
    mvent_on[channel] = int(config.get(M,'vent_on'))
    mvent_off[channel] = int(config.get(M,'vent_off'))
    for x in range(24):
      mvent_disable[x][channel] = int(config.get(M,'vent_disable_' + addzero(x)))
    for x in range(24):
      mvent_disablelowtemp[x][channel] = int(config.get(M,'vent_disablelowtemp_' + addzero(x)))
    mvent_lowtemp[channel] = int(config.get(M,'vent_lowtemp'))
    for x in range(24):
      mvent_disablehightemp[x][channel] = int(config.get(M,'vent_disablehightemp_' + addzero(x)))
    mvent_hightemp[channel] = int(config.get(M,'vent_hightemp'))
    writetodebuglog("i","CH"+ str(channel) +": Environment characteristics is loaded.")
  except:
    writetodebuglog("e","ERROR #14: Cannot open "+conffile+"!")
    exit(14)

# create and remove lock file
def lckfile(mode):
  try:
    if mode > 0:
      lcf = open(lockfile,'w')
      lcf.close()
      writetodebuglog("i","Creating lockfile.")
    else:
      writetodebuglog("i","Removing lockfile.")
      os.remove(lockfile)
  except:
    writetodebuglog("w","Cannot create/remove"+lockfile+".")

# write data to log with timestamp
def writelog(channel,temperature,humidity,gasconcentrate,statusdata):
  logfile = dir_log + '/mm8d-ch' + str(channel) + '.log'
  dt = (strftime("%Y-%m-%d,%H:%M",localtime()))
  lckfile(1)
  writetodebuglog("i","CH" + str(channel) + ": Writing data to logfile.")
  if not os.path.isfile(logfile):
    f = open(logfile,'w')
    f.close()
  try:
    with open(logfile,"r+") as f:
      first_line = f.readline()
      lines = f.readlines()
      f.seek(0)
      if (channel == 0):
        s = dt + ',' + statusdata[0] + ',' + \
                       statusdata[1] + ',' + \
                       statusdata[2] + ',' + \
                       str(temperature) + ',' + \
                       statusdata[4] + ',' + \
                       statusdata[5] + ',' + \
                       statusdata[6] + '\n'
      else:
        s = dt + ',' + str(temperature) + ',' + \
                       str(humidity) + ',' + \
                       str(gasconcentrate) + ',' + \
                       statusdata[0] + ',' + \
                       statusdata[1] + ',' + \
                       statusdata[2] + ',' + \
                       statusdata[3] + ',' + \
                       statusdata[4] + ',' + \
                       statusdata[5] + ',' + \
                       statusdata[6] + '\n'
      f.write(s)
      f.write(first_line)
      f.writelines(lines)
      f.close()
  except:
    writetodebuglog("e","ERROR #15: Cannot write " + logfile + "!")
    lckfile(0)
    exit(15)
  lckfile(0)

# check external control files
def outputoverride(channel,output,status):
  writetodebuglog("i","CH" + str(channel) + ": Checking override file " + str(output) + ".")
  if os.path.isfile(dir_var + '/' + str(channel) + "/out" + str(output)):
    try:
      f = open(dir_var + '/' + str(channel) + "/out" + str(output),'r')
      v = f.read()
      f.close()
      if v == "neutral": s = status
      if v == "off": s = "0"
      if v == "on": s = "1"
      override[channel][output] = v
    except:
      s = status
  else:
    s = status
  return s

# blink ACTIVE LED
def blinkactiveled(on):
  global led_active
  led_active = on
  writelocalports()
  return 0

# get external temperature from openweathermap.org
def getexttemp():
  writetodebuglog("i","Get external temperature from internet.")
  try:
    response=requests.get(base_url + "appid=" + api_key + "&q=" + city_name)
    x=response.json()
    if x["cod"] != "404":
      y = x["main"]
      current_temperature = y["temp"]
      current_temperature = round(current_temperature - 273)
      writetodebuglog("i","External temperature: " + str(current_temperature) + " degree Celsius")
      return current_temperature
    else:
      writetodebuglog("w","Cannot get external temperature from internet.")
      return 18
  except:
    writetodebuglog("w","Cannot get external temperature from internet.")
    return 18

# analise data
def analise(section):
  global led_error
  global led_warning
  global led_waterpumperror
  global relay_alarm
  global relay_tube1
  global relay_tube2
  global relay_tube3
  h = int(time.strftime("%H"))
  m = int(time.strftime("%M"))
  if section == 1:
    # Local inputs/outputs
    led_error = 0
    led_warning = 0
    led_waterpumperror = 0
    relay_alarm = 0
    relay_tube1 = 0
    relay_tube2 = 0
    relay_tube3 = 0
    # - opened local overcurrent breaker(s)
    if mainsbreakers == 1:
      led_error = 1
      writetodebuglog("e","Overcurrent breaker is opened!")
    # - switch on/off waterpump and valves
    if (exttemp < irtemp_min):
      relay_tube1 = 0
      relay_tube2 = 0
      relay_tube3 = 0
      writetodebuglog("w","CH0: External temperature is too low for irrigation! (< " + str(irtemp_min) + " C)")
    else:
      if (exttemp > irtemp_max):
        relay_tube1 = 0
        relay_tube2 = 0
        relay_tube3 = 0
        writetodebuglog("w","CH0: External temperature is too high for irrigation! (> " + str(irtemp_max) + " C)")
      else:
        h1, m1 = irmorning_start[1].split(':')
        h2, m2 = irmorning_stop[1].split(':')
        h3, m3 = irevening_start[1].split(':')
        h4, m4 = irevening_stop[1].split(':')
        if ((h*100+m >= int(h1)*100+int(m1)) and (h*100+m < int(h2)*100+int(m2))) or \
           ((h*100+m >= int(h3)*100+int(m3)) and (h*100+m < int(h4)*100+int(m4))):
          relay_tube1 = 1
        h1, m1 = irmorning_start[2].split(':')
        h2, m2 = irmorning_stop[2].split(':')
        h3, m3 = irevening_start[2].split(':')
        h4, m4 = irevening_stop[2].split(':')
        if ((h*100+m >= int(h1)*100+int(m1)) and (h*100+m < int(h2)*100+int(m2))) or \
           ((h*100+m >= int(h3)*100+int(m3)) and (h*100+m < int(h4)*100+int(m4))):
          relay_tube2 = 1
        h1, m1 = irmorning_start[3].split(':')
        h2, m2 = irmorning_stop[3].split(':')
        h3, m3 = irevening_start[3].split(':')
        h4, m4 = irevening_stop[3].split(':')
        if ((h*100+m >= int(h1)*100+int(m1)) and (h*100+m < int(h2)*100+int(m2))) or \
           ((h*100+m >= int(h3)*100+int(m3)) and (h*100+m < int(h4)*100+int(m4))):
          relay_tube3 = 1
    # - messages
    if relay_tube1 == 1:
      writetodebuglog("i","CH0: Output water pump and valve #1 ON")
    else:
      writetodebuglog("i","CH0: Output water pump and valve #1 OFF")
    if relay_tube2 == 1:
      writetodebuglog("i","CH0: Output water pump and valve #2 ON")
    else:
      writetodebuglog("i","CH0: Output water pump and valve #2 OFF")
    if relay_tube3 == 1:
      writetodebuglog("i","CH0: Output water pump and valve #3 ON")
    else:
      writetodebuglog("i","CH0: Output water pump and valve #3 OFF")
    # - bad pressure
    if ((relay_tube1 == 1) or (relay_tube2 == 1) or (relay_tube3 == 1)) and (waterpressurelow):
      led_waterpumperror = 1
      writetodebuglog("e","Pressure is too low after water pump!")
    if ((relay_tube1 == 1) or (relay_tube2 == 1) or (relay_tube3 == 1)) and (waterpressurehigh):
      led_waterpumperror = 1
      writetodebuglog("e","Pressure is too high after water pump!")
    # MM6D
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        # - opened doors
        if in_alarm[channel] == 1:
          relay_alarm = 1
          led_warning = 1
          writetodebuglog("w","CH"+ str(channel) +": Alarm event detected.")
          writetodebuglog("i","CH"+ str(channel) +": Restore alarm input of MM6D device.")
          if restoreMM6Dalarm(channel) == 1:
            writetodebuglog("i","CH"+ str(channel) +": Restore succeeded.")
          else:
            writetodebuglog("w","CH"+ str(channel) +": Restore failed.")
        # - bad manual switch position
        if in_swmanu[channel] == 1:
          led_warning = 1
          writetodebuglog("w","CH"+ str(channel) +": Manual mode switch is on position.")
        # - opened overcurrent breaker(s)
        if in_ocprot[channel] == 1:
          led_error = 1
          writetodebuglog("e","CH"+ str(channel) +": Overcurrent breaker of MM6D is opened!")
  else:
    # Growing environments
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        wrongdata = in_temperature[channel] + in_humidity[channel] + in_gasconcentrate[channel]
        writetodebuglog("i","CH" + str(channel) + ": Measured T is " + str(in_temperature[channel]) + " C")
        writetodebuglog("i","CH" + str(channel) + ": Measured RH is " + str(in_humidity[channel]) + "%")
        writetodebuglog("i","CH" + str(channel) + ": Measured RUGC is " + str(in_gasconcentrate[channel]) + "%")
        if wrongdata == 0:
          writetodebuglog("e","CH" + str(channel) + ": Measured data are wrong!")
        if in_opmode[channel] == 0:
          # growing mushroom
          writetodebuglog("i","CH" + str(channel) + ": Operation mode: growing mushroom.")
          # - bad temperature
          if in_temperature[channel] < mtemperature_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too low! (" + str(in_temperature[channel]) + " C < " + str(mtemperature_min[channel]) + " C)")
          if in_temperature[channel] > mtemperature_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too high! (" + str(in_temperature[channel]) + " C > " + str(mtemperature_max[channel]) + " C)")
          # - bad humidity
          if in_humidity[channel] < mhumidity_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too low! (" + str(in_humidity[channel]) + " % < " + str(mhumidity_min[channel]) + "%)")
          if in_humidity[channel] > mhumidity_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too high! (" + str(in_humidity[channel]) + " % > " + str(mhumidity_max[channel]) + "%)")
          # - bad gas concentrate
          if in_gasconcentrate[channel] > cgasconcentrate_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Unwanted gas concentrate is too high! (> " + str(cgasconcentrate_max[channel]) + "%)")
          # - heaters
          if wrongdata > 0:
            out_heaters[channel] = 0
            if in_temperature[channel] < mheater_on[channel]:
              out_heaters[channel] = 1
            if in_temperature[channel] > mheater_off[channel]:
              out_heaters[channel] = 0
            if mheater_disable[h][channel] == 1:
              out_heaters[channel] = 0
          # - lights
          out_lamps[channel] = 0
          if (h >= mlight_on1[channel]) and (h < mlight_off1[channel]):
            out_lamps[channel] = 1
          if (h >= mlight_on2[channel]) and (h < mlight_off2[channel]):
            out_lamps[channel] = 1
          # - ventilators
          out_vents[channel] = 0
          if (m > mvent_on[channel]) and (m < mvent_off[channel]):
            out_vents[channel] = 1
          if mvent_disable[h][channel] == 1:
            out_vents[channel] = 0
          if (in_humidity[channel] > mhumidity_max[channel]) and (exttemp < mtemperature_max[channel]):
            out_vents[channel] = 1
          if (in_gasconcentrate[channel] > cgasconcentrate_max[channel]) and (exttemp < mtemperature_max[channel]):
            out_vents[channel] = 1
          if (in_temperature[channel] > mtemperature_max[channel]) and (exttemp < mtemperature_max[channel]):
            out_vents[channel] = 1
        else:
          # growing hyphae
          writetodebuglog("i","CH" + str(channel) + ": Operation mode: growing hyphae.")
          # - bad temperature
          if in_temperature[channel] < htemperature_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too low! (" + str(in_temperature[channel]) + " C < " + str(htemperature_min[channel]) + " C)")
          if in_temperature[channel] > htemperature_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too high! (" + str(in_temperature[channel]) + " C > " + str(htemperature_max[channel]) + " C)")
          # - bad humidity
          if in_humidity[channel] < hhumidity_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too low! (" + str(in_humidity[channel]) + " % < " + str(hhumidity_min[channel]) + "%)")
          if in_humidity[channel] > hhumidity_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too high! (" + str(in_humidity[channel]) + " % > " + str(hhumidity_max[channel]) + "%)")
          # - bad gas concentrate
          if in_gasconcentrate[channel] > cgasconcentrate_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Unwanted gas concentrate is too high! (" + str(in_gasconcentrate[channel]) + " % > " + str(cgasconcentrate_max[channel]) + "%)")
          # - heaters
          if wrongdata > 0:
            out_heaters[channel] = 0
            if in_temperature[channel] < hheater_on[channel]:
              out_heaters[channel] = 1
            if in_temperature[channel] > hheater_off[channel]:
              out_heaters[channel] = 0
            if hheater_disable[h][channel] == 1:
              out_heaters[channel] = 0
          # - lights
          out_lamps[channel] = 0
          if (h >= hlight_on1[channel]) and (h < hlight_off1[channel]):
            out_lamps[channel] = 1
          if (h >= hlight_on2[channel]) and (h < hlight_off2[channel]):
            out_lamps[channel] = 1
          # - ventilators
          out_vents[channel] = 0
          if (m > hvent_on[channel]) and (m < hvent_off[channel]):
            out_vents[channel] = 1
          if (in_humidity[channel] > hhumidity_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
          if (in_gasconcentrate[channel] > cgasconcentrate_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
          if (in_temperature[channel] > htemperature_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
          if hvent_disablelowtemp[h][channel] == 1:
            out_vents[channel] = 0
          if hvent_disablehightemp[h][channel] == 1:
            out_vents[channel] = 0
        # messages
        if out_heaters[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": Output heaters ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": Output heaters OFF")
        if out_lamps[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": Output lamps ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": Output lamps OFF")
        if out_vents[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": Output ventilators ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": Output ventilators OFF")

# initialize GPIO/LPT port
def initializelocalports():
  writetodebuglog("i","Initializing local I/O ports.")
  if hw == 0:
    # GPIO ports
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(prt_i1,GPIO.IN)
    GPIO.setup(prt_i2,GPIO.IN)
    GPIO.setup(prt_i3,GPIO.IN)
    GPIO.setup(prt_i4,GPIO.IN)
    GPIO.setup(prt_ro1,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_ro2,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_ro3,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_ro4,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_lo1,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_lo2,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_lo3,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_lo4,GPIO.OUT,initial=GPIO.LOW)
  else:
    # paralel (LPT) port
    status = portio.ioperm(lptaddresses[prt_lpt],1,1)
    if status:
      writetodebuglog("e","ERROR #17: Cannot access I/O port: " + str(hex(lptaddresses[prt_lpt])) + "!")
      sys.exit(17)
    status = portio.ioperm(lptaddresses[prt_lpt] + 1,1,1)
    if status:
      writetodebuglog("e","ERROR #17: Cannot access I/O port: " + str(hex(lptaddresses[prt_lpt] + 1)) + "!")
      sys.exit(17)
    portio.outb(0,lptaddresses[prt_lpt])

# write data from GPIO/LPT port
def writelocalports():
  if hw == 0:
    # GPIO ports
    try:
      GPIO.output(prt_lo1,led_active)
      GPIO.output(prt_lo2,led_warning)
      GPIO.output(prt_lo3,led_error)
      GPIO.output(prt_lo4,led_waterpumperror)
      GPIO.output(prt_ro1,relay_alarm)
      GPIO.output(prt_ro2,relay_tube1)
      GPIO.output(prt_ro3,relay_tube2)
      GPIO.output(prt_ro4,relay_tube3)
      return 1
    except:
      return 0
  else:
    # paralel (LPT) port
    outdata = 128 * led_waterpumperror + \
               64 * led_error + \
               32 * led_warning + \
               16 * led_active + \
                8 * relay_tube3 + \
                4 * relay_tube2 + \
                2 * relay_tube1 + \
                    relay_alarm
    portio.outb(outdata,lptaddresses[prt_lpt])
    if (portio.inb(lptaddresses[prt_lpt]) == outdata):
      return 1
    else:
      return 0

# read data from GPIO/LPT port
def readlocalports():
  global mainsbreakers
  global waterpressurelow
  global waterpressurehigh
  global unused_local_input
  if hw == 0:
    # GPIO ports
    try:
      mainsbreakers = GPIO.input(prt_i1)
      waterpressurelow = GPIO.input(prt_i2)
      waterpressurehigh = GPIO.input(prt_i3)
      unused_local_input = GPIO.input(prt_i4)
      return 1
    except:
      mainsbreakers = 0;
      waterpressurelow = 0
      waterpressurehigh = 0
      unused_local_input = 0
      return 0
  else:
    # paralel (LPT) port
    try:
      indata = portio.inb(lptaddresses[prt_lpt] + 1)
      mainsbreakers = indata & 8
      if mainsbreakers > 1:
        mainsbreakers = 1
      waterpressurelow = indata & 16
      if waterpressurelow > 1:
        waterpressurelow = 1
      waterpressurehigh = indata & 32
      if waterpressurehigh > 1:
        waterpressurehigh = 1
      unused_local_input = indata & 64
      if unused_local_input > 1:
        unused_local_input = 1
      return 1
    except:
      mainsbreakers = 0;
      waterpressurelow = 0
      waterpressurehigh = 0
      unused_local_input = 0
      return 0

# close GPIO/LPT port
def closelocalports():
  writetodebuglog("i","Close local I/O ports.")
  if hw == 0:
    GPIO.cleanup
  else:
    portio.outb(0,lptaddresses[prt_lpt])

# read remote MM10D device
def readMM10Ddevice():
  rc = 0
  # * * * Attention! These are device dependent values! * * *
  #
  # Used ModBUS registers of the DATCON DT510 device:
  #
  #   100  active power
  #   101  reactive power
  #   102  apparant power
  #   103  effective voltage
  #   104  effective current
  #   105  power factor (cosFi)
  #
  modbus_fc = 3
  modbus_reg = 100
  modbus_regs = 6
  #
  # * * * Attention! These are device dependent values! * * *
  try:
    if pro_mm10d == HP:
      url = "http://" + adr_mm10d + "/operation/?uid=" + str(uid_mm10d) + \
            "&fc=" + str(modbus_fc) + "&reg=" + str(modbus_reg) + "&regs=" + str(modbus_regs)
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
        l = 0
        for line in r.text.splitlines():
          l = l + 1
          if l == 1:
            raw_p = int(line)
          if l == 2:
            raw_q = int(line)
          if l == 3:
            raw_s = int(line)
          if l == 4:
            raw_urms = int(line)
          if l == 5:
            raw_irms = int(line)
          if l == 6:
            raw_cosfi = int(line)
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  if rc > 0:
    # * * * Attention! These are device dependent values! * * *
    #
    # Raw and real value pairs of the DATCON DT510 device:
    #
    #   P:     32767 = 3000 W
    #   Q:     32767 = 3000 VAr
    #   S:     32767 = 3000 VA
    #   U:     32767 = 367.7 V
    #   Irms:  32767 = 8.16 A
    #   cosFi: 32767 = 1.0000
    #
    # Ratio of the current transformer: 10:1
    CT_RATIO = 10
    #
    # * * * Attention! These are device dependent values! * * *
    real_urms = str((raw_urms * 367.7) / 32767)
    real_irms = str((raw_irms * 8.16 * CT_RATIO) / 32767)
    real_cosfi = str((raw_cosfi * 1) / 32767)
    real_p = str((raw_p * 3000 * CT_RATIO) / 32767)
    real_q = str((raw_q * 3000 * CT_RATIO) / 32767)
    real_s = str((raw_s * 3000 * CT_RATIO) / 32767)
  return rc

# read and write remote MM7D device
def readwriteMM7Ddevice(channel):
  rc = 0
  try:
    if pro_mm7dch[channel] == HP:
      if in_opmode[channel] == 0:
        url = "http://" + adr_mm7dch[channel] + "/operation?uid=" + usr_uid + \
              "&h1=" + str(mhumidity_min[channel]) + "&h2=" + str(mhumidifier_on[channel]) + \
              "&h3=" + str(mhumidifier_off[channel]) + "&h4=" + str(mhumidity_max[channel]) + \
              "&t1=" + str(mtemperature_min[channel]) + "&t2=" + str(mheater_on[channel]) + \
              "&t3=" + str(mheater_off[channel]) + "&t4=" + str(mtemperature_max[channel]) + \
              "&g=" + str(cgasconcentrate_max[channel])
      else:
        url = "http://" + adr_mm7dch[channel] + "/operation?uid=" + usr_uid + \
              "&h1=" + str(hhumidity_min[channel]) + "&h2=" + str(hhumidifier_on[channel]) + \
              "&h3=" + str(hhumidifier_off[channel]) + "&h4=" + str(hhumidity_max[channel]) + \
              "&t1=" + str(htemperature_min[channel]) + "&t2=" + str(hheater_on[channel]) + \
              "&t3=" + str(hheater_off[channel]) + "&t4=" + str(htemperature_max[channel]) + \
              "&g=" + str(cgasconcentrate_max[channel])
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
        l = 0
        for line in r.text.splitlines():
          l = l + 1
          if l == 1:
            in_gasconcentrate[channel] = int(line)
          if l == 2:
            in_humidity[channel] = int(line)
          if l == 3:
            in_temperature[channel] = int(line)
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  return rc

# set automatic mode of remote MM7D device
def setautomodeMM7Ddevice(channel):
  rc = 0
  try:
    if pro_mm7dch[channel] == HP:
      url = "http://" + adr_mm7dch[channel] + "/mode/auto?uid=" + usr_uid
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  return rc

# read and write remote MM6D device
def readwriteMM6Ddevice(channel):
  rc = 0
  try:
    if pro_mm6dch[channel] == HP:
      url = "http://" + adr_mm6dch[channel] + "/operation?uid=" + usr_uid + \
            "&a=0&h=" + str(out_heaters[channel]) + "&l=" + str(out_lamps[channel]) + "&v=" + str(out_vents[channel])
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
        l = 0
        for line in r.text.splitlines():
          l = l + 1
          if l == 1:
            in_alarm[channel] = int(line)
          if l == 2:
            in_opmode[channel] = int(line)
          if l == 3:
            in_swmanu[channel] = int(line)
          if l == 4:
            in_ocprot[channel] = int(line)
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  return rc

# set default state of remote MM6D device
def resetMM6Ddevice(channel):
  rc = 0
  try:
    if pro_mm6dch[channel] == HP:
      url = "http://" + adr_mm6dch[channel] + "/set/all/off?uid=" + usr_uid
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  return rc

# restore alarm input of remote MM6D device
def restoreMM6Dalarm(channel):
  rc=0
  try:
    if pro_mm6dch[channel] == HP:
      url="http://"+adr_mm6dch[channel]+"/set/alarm/off?uid="+usr_uid
      r=requests.get(url,timeout=3)
      if (r.status_code==200):
        rc=1
      else:
        rc=0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
      rc=0
  return rc

# get version of remote MM6D, MM7D and MM10D device
def getcontrollerversion(conttype,channel):
  global mv
  global sv
  mv = 0
  sv = 0
  rc = 0
  if conttype == 6:
    protocol = pro_mm6dch[channel]
    url = "http://" + adr_mm6dch[channel] + "/version"
  if conttype == 7:
    protocol = pro_mm7dch[channel]
    url = "http://" + adr_mm7dch[channel] + "/version"
  if conttype == 10:
    protocol = pro_mm10d
    url = "http://" + adr_mm10 + "/version"
  try:
    if protocol == HP:
      r = requests.get(url,timeout = 3)
      if r.status_code == 200:
        rc = 1
        l = 0
        for line in r.text.splitlines():
          l = l + 1
          if l == 2:
            mv = int(line[0])
            sv = int(line[2])
            break
      else:
        rc = 0
    else:
      # The location of the ModBUS communication procedure, this will be
      # included in the next release. Its return value now indicates a
      # failed connection.
      rc = 0
  except:
    rc = 0
  return rc

# main program
global cgasconcentrate_max
global com
global exttemp
global hheater_disable
global hheater_off
global hheater_on
global hhumidifier_disable
global hhumidifier_off
global hhumidifier_on
global hhumidity_max
global hhumidity_min
global hlight_off1
global hlight_off2
global hlight_on1
global hlight_on2
global htemperature_max
global htemperature_min
global hvent_disable
global hvent_disablehightemp
global hvent_disablelowtemp
global hvent_hightemp
global hvent_lowtemp
global hvent_off
global hvent_on
global in_alarm
global in_gasconcentrate
global in_humidity
global in_ocprot
global in_opmode
global in_swmanu
global in_temperature
global led_active
global led_error
global led_warning
global led_waterpumperror
global loop
global mheater_disable
global mheater_off
global mheater_on
global mhumidifier_disable
global mhumidifier_off
global mhumidifier_on
global mhumidity_max
global mhumidity_min
global mlight_off1
global mlight_off2
global mlight_on1
global mlight_on2
global mtemperature_max
global mtemperature_min
global mvent_disable
global mvent_disablehightemp
global mvent_disablelowtemp
global mvent_hightemp
global mvent_lowtemp
global mvent_off
global mvent_on
global out_heaters
global out_lamps
global out_vents
global override
global raw_cosfi
global raw_irms
global raw_p
global raw_q
global raw_s
global raw_urms
global real_cosfi
global real_irms
global real_p
global real_q
global real_s
global real_urms
global relay_alarm
global relay_tube1
global relay_tube2
global relay_tube3
# reset variables
cgasconcentrate_max = [0 for x in range(9)]
done = 0
exttemp = 18
hheater_disable = [[0 for x in range(9)] for y in range(24)]
hheater_off = [0 for x in range(9)]
hheater_on = [0 for x in range(9)]
hhumidifier_off = [0 for x in range(9)]
hhumidifier_on = [0 for x in range(9)]
hhumidity_max = [0 for x in range(9)]
hhumidity_min = [0 for x in range(9)]
hlight_off1 = [0 for x in range(9)]
hlight_off2 = [0 for x in range(9)]
hlight_on1 = [0 for x in range(9)]
hlight_on2 = [0 for x in range(9)]
htemperature_max = [0 for x in range(9)]
htemperature_min = [0 for x in range(9)]
hvent_disable = [[0 for x in range(9)] for x in range(24)]
hvent_disablehightemp = [[0 for x in range(9)] for x in range(24)]
hvent_disablelowtemp = [[0 for x in range(9)] for x in range(24)]
hvent_hightemp = [0 for x in range(9)]
hvent_lowtemp = [0 for x in range(9)]
hvent_off = [0 for x in range(9)]
hvent_on = [0 for x in range(9)]
in_alarm = [0 for channel in range(9)]
in_gasconcentrate = [0 for channel in range(9)]
in_humidity = [0 for channel in range(9)]
in_ocprot = [0 for channel in range(9)]
in_opmode = [0 for channel in range(9)]
in_swmanu = [0 for channel in range(9)]
in_temperature = [0 for channel in range(9)]
led_active = 0
led_error = 0
led_warning = 0
led_waterpumperror = 0
loop = 0
mheater_disable = [[0 for x in range(9)] for y in range(24)]
mheater_off = [0 for x in range(9)]
mheater_on = [0 for x in range(9)]
mhumidifier_off = [0 for x in range(9)]
mhumidifier_on = [0 for x in range(9)]
mhumidity_max = [0 for x in range(9)]
mhumidity_min = [0 for x in range(9)]
mlight_off1 = [0 for x in range(9)]
mlight_off2 = [0 for x in range(9)]
mlight_on1 = [0 for x in range(9)]
mlight_on2 = [0 for x in range(9)]
mtemperature_max = [0 for x in range(9)]
mtemperature_min = [0 for x in range(9)]
mvent_disable = [[0 for x in range(9)] for x in range(24)]
mvent_disablehightemp = [[0 for x in range(9)] for x in range(24)]
mvent_disablelowtemp = [[0 for x in range(9)] for x in range(24)]
mvent_hightemp = [0 for x in range(9)]
mvent_lowtemp = [0 for x in range(9)]
mvent_off = [0 for x in range(9)]
mvent_on = [0 for x in range(9)]
newdata_ch = ["" for x in range(10)]
newdata_ps = ""
out_heaters = [0 for channel in range(9)]
out_lamps = [0 for channel in range(9)]
out_vents = [0 for channel in range(9)]
override = [["neutral" for x in range(4)] for x in range(9)]
prevdata_ch = ["" for x in range(10)]
prevdata_ps = ""
raw_cosfi = 0
raw_irms = 0
raw_p = 0
raw_q = 0
raw_s = 0
raw_urms = 0
real_cosfi = "1"
real_irms = "0"
real_p = "0"
real_q = "0"
real_s = "0"
real_urms = "0"
relay_alarm = 0
relay_tube1 = 0
relay_tube2 = 0
relay_tube3 = 0
# load main settings
loadconfiguration(confdir + "mm8d.ini")
# intialize serial port
if ena_console == "1":
  com = serial.Serial(prt_com, com_speed)
# load irrigator settings
loadirrconf(confdir + "irrigator.ini")
# checking version of remote devices
for channel in range(1,9):
  if ena_ch[channel] > 0:
    if getcontrollerversion(6,channel):
      if (mv * 10 + sv) < (COMPMV6 * 10 + COMPSV6):
        ena_ch[channel] = 0;
        writetodebuglog("w","CH"+ str(channel) +": Version of MM6D is not compatible.")
    else:
      ena_ch[channel] = 0;
      writetodebuglog("w","CH"+ str(channel) +": MM6D is not accessible.")
for channel in range(1,9):
  if ena_ch[channel] > 0:
    if getcontrollerversion(7,channel):
      if (mv * 10 + sv) < (COMPMV7 * 10 + COMPSV7):
        ena_ch[channel] = 0;
        writetodebuglog("w","CH"+ str(channel) +": Version of MM7D is not compatible.")
    else:
      ena_ch[channel] = 0;
      writetodebuglog("w","CH"+ str(channel) +": MM7D is not accessible.")
if ena_mm10d > 0:
  if getcontrollerversion(10,1):
    if (mv * 10 + sv) < (COMPMV6 * 10 + COMPSV6):
      ena_mm10d = 0;
      writetodebuglog("w","Version of MM10D is not compatible.")
  else:
    ena_mm10d = 0;
    writetodebuglog("w","MM10D is not accessible.")
# check number of enabled channels
ii = 0;
for channel in range(1,9):
  ii=ii+ena_ch[channel];
if ii == 0:
  writetodebuglog("e","ERROR #18: There is not enabled channel!")
  exit(18);
# load environment parameter settings
for channel in range(1,9):
  if ena_ch[channel] == 1:
    loadenvirconf(channel,confdir + "envir-ch" + str(channel) + ".ini")
# initialize local ports to default state
initializelocalports()
# set auto mode of MM7D device
for channel in range(1,9):
  if ena_ch[channel] == 1:
    if setautomodeMM7Ddevice(channel):
      writetodebuglog("i","CH"+ str(channel) +": Set auto mode of MM7D.")
    else:
      writetodebuglog("w","CH"+ str(channel) +": Cannot set auto mode of MM7D.")
exttemp = getexttemp()
# *** start loop ***
writetodebuglog("i","Starting program as daemon.")
while True:
  try:
    time.sleep(1)
    blinkactiveled(1);
    # section #1:
    # read data from local port
    writetodebuglog("i","Read data from local I/O port.")
    if readlocalports():
      writetodebuglog("i","- input data: " + str(unused_local_input) + \
                                             str(waterpressurehigh) + \
                                             str(waterpressurelow) + \
                                             str(mainsbreakers) +".")
    else:
      writetodebuglog("w","Cannot read data from local I/O port.")
    # analise data
    analise(1);
    # override state of outputs
    relay_tube1 = int(outputoverride(0,1,relay_tube1))
    relay_tube2 = int(outputoverride(0,2,relay_tube2))
    relay_tube3 = int(outputoverride(0,3,relay_tube3))
    if relay_tube1 == 1:
      writetodebuglog("i","CH0: -> water pump and valve #1 ON")
    else:
      writetodebuglog("i","CH0: -> water pump and valve #1 OFF")
    if relay_tube2 == 1:
      writetodebuglog("i","CH0: -> water pump and valve #2 ON")
    else:
      writetodebuglog("i","CH0: -> water pump and valve #2 OFF")
    if relay_tube3 == 1:
      writetodebuglog("i","CH0: -> water pump and valve #3 ON")
    else:
      writetodebuglog("i","CH0: -> water pump and valve #3 OFF")
    # write data to local port
    writetodebuglog("i","Write data to local I/O port.")
    if writelocalports():
      writetodebuglog("i","- output data: " + str(led_waterpumperror) + \
                                              str(led_error) + \
                                              str(led_warning) + \
                                              str(led_active) + \
                                              str(relay_tube3) + \
                                              str(relay_tube2) + \
                                              str(relay_tube1) + \
                                              str(relay_alarm) +".")
    else:
      writetodebuglog("w","Cannot write data to local I/O port.")
    # set outputs of MM6D
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        if readwriteMM6Ddevice(channel):
          writetodebuglog("i","CH"+ str(channel) +": Set outputs of MM6D.")
        else:
          writetodebuglog("w","CH"+ str(channel) +": Cannot set outputs of MM6D.")
    # section #2:
    # get power supply data from MM10D
    if ena_mm10d == 1:
      if readwriteMM10Ddevice():
        writetodebuglog("i","Get power supply data from MM10D.")
      else:
        writetodebuglog("w","Cannot get power supply data from MM10D.")
    # get parameters of air from MM7Ds
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        if readwriteMM7Ddevice(channel):
          writetodebuglog("i","CH"+ str(channel) +": Get parameters of air from MM7D.")
        else:
          writetodebuglog("w","CH"+ str(channel) +": Cannot get parameters of air from MM7D.")
        if setautomodeMM7Ddevice(channel):
          writetodebuglog("i","CH"+ str(channel) +": Set auto mode of MM7D.")
        else:
          writetodebuglog("w","CH"+ str(channel) +": Cannot set auto mode of MM7D.")
    # get external temperature from internet
    if (int(time.strftime("%M")) == 0) or (int(time.strftime("%M")) == 1):
      if done == 0:
        exttemp = getexttemp()
        done = 1
    if (int(time.strftime("%M")) == 30) or (int(time.strftime("%M")) == 31):
      done = 0
    # analise data
    analise(2);
    # override state of outputs
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        out_lamps[channel] = outputoverride(channel,1,out_lamps[channel])
        out_vents[channel] = outputoverride(channel,2,out_vents[channel])
        out_heaters[channel] = outputoverride(channel,3,out_heaters[channel])
        if out_heaters[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": -> heaters ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": -> heaters OFF")
        if out_lamps[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": -> lamps ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": -> lamps OFF")
        if out_vents[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": -> ventilators ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": -> ventilators OFF")
    # write data to mm8d-supply.log
    newdata_ps = real_urms + real_irms + real_p + real_q + real_s + real_cosfi
    if (prevdata_ps != newdata_ps:
      # !!!! writelog(0,0,0,0,newdata_ch[0]) !!!
      prevdata_ps = newdata_ps
    # write data to mm8d-ch0.log
    newdata_ch[0] = str(mainsbreakers) + \
                 str(waterpressurelow) + \
                 str(waterpressurehigh) + \
                 str(unused_local_input) + \
                 str(relay_tube1) + \
                 str(relay_tube2) + \
                 str(relay_tube3)
    if (prevdata_ch[0] != str(exttemp) + newdata_ch[0]):
      writelog(0,exttemp,0,0,newdata_ch[0])
      prevdata_ch[0] = str(exttemp) + newdata_ch[0]
    # write data to mm8d-ch[1-8].log
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        if in_temperature[channel] + in_humidity[channel] + in_gasconcentrate[channel] > 0:
          newdata_ch[channel] = str(in_opmode[channel]) + \
                             str(in_swmanu[channel]) + \
                             str(in_ocprot[channel]) + \
                             str(in_alarm[channel]) + \
                             str(out_lamps[channel]) + \
                             str(out_vents[channel]) + \
                             str(out_heaters[channel])
          if (prevdata_ch[channel] != str(in_temperature[channel]) + str(in_humidity[channel]) + str(in_gasconcentrate[channel]) + newdata_ch[channel]):
            writelog(channel, in_temperature[channel],in_humidity[channel],in_gasconcentrate[channel],newdata_ch[channel])
            prevdata_ch[channel] = str(in_temperature[channel]) + str(in_humidity[channel]) + str(in_gasconcentrate[channel]) + newdata_ch[channel]
    # send power supply data to display via serial port
    writepowersupplydatatocomport()
    delay(0.5)
    # send channels' data to display via serial port
    writechannelstatustocomport(loop)
    if loop == 8:
      loop = 0
    else:
      loop = loop + 1
    # waiting
    blinkactiveled(0);
    writetodebuglog("i","Waiting " + str(DELAY) + " seconds.")
    time.sleep(DELAY)
  except:
    # *** stop loop ***
    writetodebuglog("e","ERROR #19: Fatal error!")
    # close local ports
    closelocalports()
    # set outputs of MM6D
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        if resetMM6Ddevice(channel):
          writetodebuglog("i","CH"+ str(channel) +": Set outputs of MM6D to default state.")
        else:
          writetodebuglog("w","CH"+ str(channel) +": Cannot set outputs of MM6D to default state.")
    writetodebuglog("i","Program stopped.")
    sys.exit(19)
# close local ports
closelocalports()
# set outputs of MM6D
for channel in range(1,9):
  if ena_ch[channel] == 1:
    if resetMM6Ddevice(channel):
      writetodebuglog("i","CH"+ str(channel) +": Set outputs of MM6D to default state.")
    else:
      writetodebuglog("w","CH"+ str(channel) +": Cannot set outputs of MM6D to default state.")
writetodebuglog("i","Program stopped.")
sys.exit(0)
