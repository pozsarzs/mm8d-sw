#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.2 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020-2022 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | mm8d.py                                                                    |
# | Main program                                                               |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
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

import configparser
import daemon
import io
import json
import os
import platform
import requests
import sys
import time
from time import gmtime, strftime

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
DELAY=10

global lptaddresses
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
  if dbg_log == "1":
    if level == "i":
      lv = "INFO   "
    if level == "w":
      lv = "WARNING"
    if level == "e":
      lv = "ERROR  "
    debugfile = dir_log + '/' + time.strftime("debug-%Y%m%d.log")
    dt = (strftime("%Y-%m-%d %H:%M:%S", gmtime()))
    try:
      with open(debugfile,"a") as d:
        d.write(dt + '  ' + lv + ' ' + text + '\n')
        d.close()
    except:
      print ("")

# load configuration
def loadconfiguration(conffile):
  global adr_mm6dch
  global adr_mm7dch
  global api_key
  global base_url
  global city_name
  global dbg_log
  global dir_log
  global dir_var
  global ena_ch
  global lockfile
  global logfile
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
    global lpt_prt

  try:
    with open(conffile) as f:
      mainconfig = f.read()
    config = configparser.RawConfigParser(allow_no_value = True)
    config.read_file(io.StringIO(mainconfig))
    adr_mm6dch = [0 for x in range(9)]
    for i in range(1,9):
      adr_mm6dch[i] = config.get('MM6D','adr_mm6dch' + str(i))
    adr_mm7dch = [0 for x in range(9)]
    for i in range(1,9):
      adr_mm7dch[i] = config.get('MM7D','adr_mm7dch' + str(i))
    api_key = config.get('openweathermap.org','api_key')
    base_url = config.get('openweathermap.org','base_url')
    city_name = config.get('openweathermap.org','city_name')
    dbg_log = '0'
    dbg_log = config.get('log','dbg_log')
    dir_log = config.get('directories','dir_log')
    dir_var = config.get('directories','dir_var')
    ena_ch = [0 for x in range(9)]
    for i in range(1,9):
      ena_ch[i] = int(config.get('enable','ena_ch' + str(i)))
    lockfile = config.get('directories','dir_lck') + 'mm8d.lck'
    usr_uid = config.get('user','usr_uid')
    if hw == 0:
      prt_i1 = int(config.get('GPIOports','prt_i1'))
      prt_i2 = int(config.get('GPIOports','prt_i2'))
      prt_i3 = int(config.get('GPIOports','prt_i3'))
      prt_i4 = int(config.get('GPIOports','prt_i4'))
      prt_ro1 = int(config.get('GPIOports','prt_ro1'))
      prt_ro2 = int(config.get('GPIOports','prt_ro2'))
      prt_ro3 = int(config.get('GPIOports','prt_ro3'))
      prt_ro4 = int(config.get('GPIOports','prt_ro4'))
      prt_lo1 = int(config.get('GPIOports','prt_lo1'))
      prt_lo2 = int(config.get('GPIOports','prt_lo2'))
      prt_lo3 = int(config.get('GPIOports','prt_lo3'))
      prt_lo4 = int(config.get('GPIOports','prt_lo4'))
    else:
      lpt_prt = int(config.get('LPTport','lpt_prt'))
    writetodebuglog("i","Configuration is loaded.")
  except:
    writetodebuglog("e","ERROR #01: Cannot open " + conffile + "!")
    exit(1)

# load configuration
def loadirrconf(conffile):
  C = "common"
  T = "tube-"
  try:
    with open(conffile) as f:
      mainconfig = f.read()
    config = configparser.RawConfigParser(allow_no_value = True)
    config.read_file(io.StringIO(mainconfig))
    irtemp_max = int(config.get(C,'temp_max'))
    irtemp_min = int(config.get(C,'temp_min'))
    for i in range(1,4):
      irevening_start = config.get(T + str(i),'evening_start')
      irevening_stop = config.get(T + str(i),'evening_stop')
      irmorning_start = config.get(T + str(i),'morning_start')
      irmorning_stop = config.get(T + str(i),'morning_stop')
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
  dt = (strftime("%Y-%m-%d,%H:%M",gmtime()))
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
        s = dt + ',' + \
            statusdata[0] + ',' + statusdata[1] + ',' + statusdata[2] + ',' + statusdata[3] + '\n'
      else:
        s = dt + ',' + \
            str(temperature) + ',' + str(humidity) + ',' + str(gasconcentrate) + ',' + \
              statusdata[0] + ',' + statusdata[1] + ',' + statusdata[2] + ',' + \
              statusdata[3] + ',' + statusdata[4] + ',' + statusdata[5] + ',' + \
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

# analise data
def analise(section):
  global led_active
  global led_error
  global led_warning
  global led_waterpumperror
  global relay_alarm
  global relay_tube1
  global relay_tube2
  global relay_tube3
  h=int(time.strftime("%H"))
  m=int(time.strftime("%M"))
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


#   if (bekapcsolva kell lennie az 1-esnek):
#      relay_tube = 1
#    if (bekapcsolva kell lennie az 2-esnek):
#      relay_tube = 2
#    if (bekapcsolva kell lennie az 3-esnek):
#      relay_tube = 3


    # messages
    if relay_tube = 1:
      writetodebuglog("i","CH0: water pump and valve #1 ON")
    else:
      writetodebuglog("i","CH0: water pump and valve #1 OFF")
    if relay_tube = 2:
      writetodebuglog("i","CH0: water pump and valve #2 ON")
    else:
      writetodebuglog("i","CH0: water pump and valve #2 OFF")
    if relay_tube = 3:
      writetodebuglog("i","CH0: water pump and valve #3 ON")
    else:
      writetodebuglog("i","CH0: water pump and valve #3 OFF")
    # - bad pressure
    if ((relay_tube1 = 1) or (relay_tube2 = 1) or (relay_tube3 = 1)) and (waterpressurelow):
      led_waterpumperror = 1
      writetodebuglog("e","Pressure is too low after water pump!")
    if ((relay_tube1 = 1) or (relay_tube2 = 1) or (relay_tube3 = 1)) and (waterpressurehigh):
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
        writetodebuglog("i","CH" + str(channel) + ": " + str(in_temperature[channel]) + " C")
        writetodebuglog("i","CH" + str(channel) + ": " + str(in_humidity[channel]) + "%")
        writetodebuglog("i","CH" + str(channel) + ": " + str(in_gasconcentrate[channel]) + "%")
        if in_opmode[channel] == 0:
          # growing mushroom
          writetodebuglog("i","CH" + str(channel) + ": operation mode: growing mushroom.")
          # - bad temperature
          if in_temperature[channel] < mtemperature_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too low! (< " + str(mtemperature_min[channel]) + " C)")
          if in_temperature[channel] > mtemperature_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too high! (> " + str(mtemperature_max[channel]) + " C)")
          # - bad humidity
          if in_humidity[channel] < mhumidity_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too low! (< " + str(mhumidity_min[channel]) + "%)")
          if in_humidity[channel] > mhumidity_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too high! (< " + str(mhumidity_max[channel]) + "%)")
          # - bad gas concentrate
          if in_gasconcentrate[channel] > cgasconcentrate_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Unwanted gas concentrate is too high! (< " + str(cgasconcentrate_max[channel]) + "%)")
          # - heaters
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
          writetodebuglog("i","CH" + str(channel) + ": operation mode: growing hyphae.")
          # - bad temperature
          if in_temperature[channel] < htemperature_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too low! (< " + str(htemperature_min[channel]) + " C)")
          if in_temperature[channel] > htemperature_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Temperature is too high! (> " + str(htemperature_max[channel]) + " C)")
          # - bad humidity
          if in_humidity[channel] < hhumidity_min[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too low! (< " + str(hhumidity_min[channel]) + "%)")
          if in_humidity[channel] > hhumidity_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Relative humidity is too high! (< " + str(hhumidity_max[channel]) + "%)")
          # - bad gas concentrate
          if in_gasconcentrate[channel] > cgasconcentrate_max[channel]:
            writetodebuglog("w","CH" + str(channel) + ": Unwanted gas concentrate is too high! (< " + str(cgasconcentrate_max[channel]) + "%)")
          # - heaters
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
          if hvent_disable[h][channel] == 1:
            out_vents[channel] = 0
          if (in_humidity[channel] > hhumidity_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
          if (in_gasconcentrate[channel] > cgasconcentrate_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
          if (in_temperature[channel] > htemperature_max[channel]) and (exttemp < htemperature_max[channel]):
            out_vents[channel] = 1
        # messages
        if out_heaters[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": heaters ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": heaters OFF")
        if out_lamps[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": lamps ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": lamps OFF")
        if out_vents[channel] == 1:
          writetodebuglog("i","CH" + str(channel) + ": ventilators ON")
        else:
          writetodebuglog("i","CH" + str(channel) + ": ventilators OFF")

# initialize GPIO/LPT port
def initializelocalports():
  writetodebuglog("i","Initializing local I/O ports.")
  if hw == 0:
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
    status = portio.ioperm(lptaddresses[lpt_prt],1,1)
    if status:
      writetodebuglog("e","ERROR #17: Cannot access I/O port:" + str(hex(lptaddresses[lpt_prt])) + "!")
      sys.exit(17)
    status = portio.ioperm(lptaddresses[lpt_prt] + 1,1,1)
    if status:
      writetodebuglog("e","ERROR #17: Cannot access I/O port:" + str(hex(lptaddresses[lpt_prt] + 1)) + "!")
      sys.exit(17)
    portio.outb(0,lptaddresses[lpt_prt])

# write data from GPIO/LPT port
def writelocalports():
  if hw == 0:
    GPIO.output(prt_lo1,led_active)
    GPIO.output(prt_lo2,led_warning)
    GPIO.output(prt_lo3,led_error)
    GPIO.output(prt_lo4,led_waterpumperror)
    GPIO.output(prt_ro1,relay_alarm)
    GPIO.output(prt_ro2,relay_irrtube1)
    GPIO.output(prt_ro3,relay_irrtube2)
    GPIO.output(prt_ro4,relay_irrtube3)
    return 0
  else:
    outdata = 128 * led_waterpumperror + \
               64 * led_error + \
               32 * led_warning + \
               16 * led_active + \
                8 * relay_irrtube3 + \
                4 * relay_irrtube2 + \
                2 * relay_irrtube1 + \
                    relay_alarm
    portio.outb(outdata,lptaddresses[lpt_prt])
    if (portio.inb(lptaddresses[lpt_prt]) == outdata):
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
    GPIO.input(prt_i1,mainsbreakers)
    GPIO.input(prt_i2,waterpressurelow)
    GPIO.input(prt_i3,waterpressurehigh)
    GPIO.input(prt_i4,unused_local_input)
  else:
    indata = portio.inb(lptaddresses[lpt_prt] + 1)
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

# close GPIO/LPT port
def closelocalports():
  writetodebuglog("i","Close local I/O ports.")
  if hw == 0:
    GPIO.cleanup
  else:
    portio.outb(0,lptaddresses[lpt_prt])

# read and write remote MM7D device
def readwriteMM7Ddevice(channel):
  rc = 0
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
  try:
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
  except:
    rc = 0
  return rc

# set automatic mode of remote MM7D device
def setautomodeMM7Ddevice(channel):
  rc = 0
  url = "http://" + adr_mm7dch[channel] + "/mode/auto?uid=" + usr_uid
  try:
    r = requests.get(url,timeout = 3)
    if r.status_code == 200:
      rc = 1
    else:
      rc = 0
  except:
    rc = 0
  return rc

# read and write remote MM6D device
def readwriteMM6Ddevice(channel):
  rc = 0
  url = "http://" + adr_mm6dch[channel] + "/operation?uid=" + usr_uid + \
    "&a=0&h=" + str(out_heaters[channel]) + "&l=" + str(out_lamps[channel]) + "&v=" + str(out_vents[channel])
  try:
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
  except:
    rc = 0
  return rc

# set default state of remote MM6D device
def resetMM6Ddevice(channel):
  rc = 0
  url = "http://" + adr_mm6dch[channel] + "/set/all/off?uid=" + usr_uid
  try:
    r = requests.get(url,timeout = 3)
    if r.status_code == 200:
      rc = 1
    else:
      rc = 0
  except:
    rc = 0
  return rc

# restore alarm input of remote MM6D device
def restoreMM6Dalarm(channel):
  rc=0
  url="http://"+adr_mm6dch[channel]+"/set/alarm/off?uid="+usr_uid
  try:
    r=requests.get(url,timeout=3)
    if (r.status_code==200):
      rc=1
    else:
      rc=0
  except:
    rc=0
  return rc

# get version of remote MM6D and MM7D device
def getcontrollerversion(conttype,channel):
  global mv
  global sv
  mv = 0
  sv = 0
  rc = 0
  if conttype == 6:
    url = "http://" + adr_mm6dch[channel] + "/version"
  else:
    url = "http://" + adr_mm7dch[channel] + "/version"
  try:
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
  except:
    rc = 0
  return rc

# main program
global cgasconcentrate_max
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
global hvent_disablelowtemp
global hvent_lowtemp
global hvent_off
global hvent_on
global in_alarm
global in_gasconcentrate
global irevening_start
global irevening_stop
global irmorning_start
global irmorning_stop
global irtemp_max
global irtemp_min
global in_humidity
global in_ocprot
global in_opmode
global in_swmanu
global in_temperature
global led_active
global led_error
global led_warning
global led_waterpumperror
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
global mvent_disablelowtemp
global mvent_lowtemp
global mvent_off
global mvent_on
global out_heaters
global out_lamps
global out_vents
global relay_alarm
global relay_tube1
global relay_tube2
global relay_tube3
# reset variables
cgasconcentrate_max = [0 for x in range(9)]
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
hvent_disablelowtemp = [[0 for x in range(9)] for x in range(24)]
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
irevening_start = [0 for channel in range(4)]
irevening_stop = [0 for channel in range(4)]
irmorning_start = [0 for channel in range(4)]
irmorning_stop = [0 for channel in range(4)]
irtemp_max = 0
irtemp_min = 0
led_active = 0
led_error = 0
led_warning = 0
led_waterpumperror = 0
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
mvent_disablelowtemp = [[0 for x in range(9)] for x in range(24)]
mvent_lowtemp = [0 for x in range(9)]
mvent_off = [0 for x in range(9)]
mvent_on = [0 for x in range(9)]
newdata = ["" for x in range(10)]
out_heaters = [0 for channel in range(9)]
out_lamps = [0 for channel in range(9)]
out_vents = [0 for channel in range(9)]
prevdata = ["" for x in range(10)]
relay_alarm = 0
relay_tube1 = 0
relay_tube2 = 0
relay_tube3 = 0
# load main settings
loadconfiguration(confdir + "mm8d.ini")
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
# *** start loop ***
writetodebuglog("i","Starting program as daemon.")
while True:
  try:
    time.sleep(1)
    blinkactiveled(1);
    # section #1:
    # read data from local port
    if readlocalports():
      writetodebuglog("i","Read data from local I/O port.")
    else:
      writetodebuglog("w","Cannot read data from local I/O port.")
    # analise data
    analise(1);
    # override state of outputs
    relay_tube1 = outputoverride(0,1,relay_tube1)
    relay_tube2 = outputoverride(0,1,relay_tube2)
    relay_tube3 = outputoverride(0,1,relay_tube3)
    # write data to local port
    if writelocalports():
      writetodebuglog("i","Write data to local I/O port.")
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
    if (int(time.strftime("%M")) == 28):
      exttemp=getexttemp()
    # analise data
    analise(2);
    # override state of outputs
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        out_lamps[channel] = outputoverride(channel,1,out_lamps[channel])
        out_vents[channel] = outputoverride(channel,2,out_vents[channel])
        out_heaters[channel] = outputoverride(channel,3,out_heaters[channel])
    # write data to log
    newdata[0] = str(mainssensor) + str(mainsbreaker1) + str(mainsbreaker2) + str(mainsbreaker3)
    if (prevdata[0] != newdata[0]):
      writelog(0,0,0,0,newdata[0])
      prevdata[0] = newdata[0]
    for channel in range(1,9):
      if ena_ch[channel] == 1:
        newdata[channel] = str(in_opmode[channel]) + str(in_swmanu[channel]) + str(in_ocprot[channel]) + str(in_alarm[channel]) + \
                           str(out_lamps[channel]) + str(out_vents[channel]) + str(out_heaters[channel])
        if (prevdata[channel] != newdata[channel]):
          writelog(channel, in_temperature[channel],in_humidity[channel],in_gasconcentrate[channel],newdata[channel])
          prevdata[channel] = newdata[channel]
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
    sys.exit(0)
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
