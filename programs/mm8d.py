#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.1 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020-2021 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
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
#  15: cannot create lock file
#  17: cannot access i/o port

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
if (arch.find("86") > -1):
  hw=1
  import portio
else:
  hw=0
  import RPi.GPIO as GPIO

USRLOCALDIR = 1
if (USRLOCALDIR == 1):
  confdir='/usr/local/etc/mm8d/'
else:
  confdir='/etc/mm8d/'

COMPMV6=0
COMPSV6=3
COMPMV7=0
COMPSV7=3

global lptaddresses
lptaddresses = [0x378,0x278,0x3bc]

# add a zero char
def addzero(num):
  if num<10:
    z="0"
  else:
    z=""
  s=z+str(num)
  return s

# initializing ports
def initports():
  writetodebuglog("i","Initializing I/O ports.")
  if (hw==0):
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
    status = portio.ioperm(lptaddresses[lpt_prt], 1, 1)
    if status:
      print("ERROR #17: Cannot access I/O port:",hex(lptaddresses[lpt_prt]));
      sys.exit(17)
    status = portio.ioperm(lptaddresses[lpt_prt]+1, 1, 1)
    if status:
      print("ERROR #17: Cannot access I/O port:",hex(lptaddresses[lpt_prt]+1));
      sys.exit(17)
    portio.outb(0,lptaddresses[lpt_prt])

# write a line to debug logfile
def writetodebuglog(level,text):
  if dbg_log=="1":
    if level=="i":
      lv="INFO   "
    if level=="w":
      lv="WARNING"
    if level=="e":
      lv="ERROR  "
    debugfile=dir_log+'/'+time.strftime("debug-%Y%m%d.log")
    dt=(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
    try:
      with open(debugfile, "a") as d:
        d.write(dt+'  '+lv+' '+text+'\n')
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
  global lpt_prt
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
  global usr_uid
  try:
    with open(conffile) as f:
      mainconfig=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mainconfig))
    adr_mm6dch=[0 for x in range(9)]
    for i in range(1,9):
      adr_mm6dch[i]=config.get('MM6D','adr_mm6dch'+str(i))
    adr_mm7dch=[0 for x in range(9)]
    for i in range(1,9):
      adr_mm7dch[i]=config.get('MM7D','adr_mm7dch'+str(i))
    api_key=config.get('openweathermap.org','api_key')
    base_url=config.get('openweathermap.org','base_url')
    city_name=config.get('openweathermap.org','city_name')
    dbg_log='0'
    dbg_log=config.get('log','dbg_log')
    dir_log=config.get('directories','dir_log')
    dir_var=config.get('directories','dir_var')
    ena_ch=[0 for x in range(9)]
    for i in range(1,9):
      ena_ch[i]=int(config.get('enable','ena_ch'+str(i)))
    lockfile=config.get('directories','dir_lck')+'mm8d.lck'
    prt_i1=int(config.get('GPIOports','prt_i1'))
    prt_i2=int(config.get('GPIOports','prt_i2'))
    prt_i3=int(config.get('GPIOports','prt_i3'))
    prt_i4=int(config.get('GPIOports','prt_i4'))
    prt_ro1=int(config.get('GPIOports','prt_ro1'))
    prt_ro2=int(config.get('GPIOports','prt_ro2'))
    prt_ro3=int(config.get('GPIOports','prt_ro3'))
    prt_ro4=int(config.get('GPIOports','prt_ro4'))
    prt_ro1=int(config.get('GPIOports','prt_lo1'))
    prt_lo2=int(config.get('GPIOports','prt_lo2'))
    prt_lo3=int(config.get('GPIOports','prt_lo3'))
    prt_lo4=int(config.get('GPIOports','prt_lo4'))
    lpt_prt=int(config.get('LPTport','lpt_prt'))
    usr_uid=config.get('user','usr_uid')
    writetodebuglog("i","Configuration is loaded.")
  except:
    writetodebuglog("e","Cannot open "+conffile+"!")
    exit(1)

# load environment characteristics
def loadenvirchars(channel,conffile):
  global gasconcentrate_max
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
  C="common"
  H="hyphae"
  M="mushroom"
  gasconcentrate_max=[0 for x in range(9)]
  hhumidifier_off=[0 for x in range(9)]
  hhumidity_max=[0 for x in range(9)]
  hhumidity_min=[0 for x in range(9)]
  hhumidifier_on=[0 for x in range(9)]
  htemperature_max=[0 for x in range(9)]
  hheater_off=[0 for x in range(9)]
  hheater_on=[0 for x in range(9)]
  htemperature_min=[0 for x in range(9)]
  hheater_disable=[[0 for x in range(9)] for y in range(24)]
  hlight_off1=[0 for x in range(9)]
  hlight_off2=[0 for x in range(9)]
  hlight_on1=[0 for x in range(9)]
  hlight_on2=[0 for x in range(9)]
  hvent_on=[0 for x in range(9)]
  hvent_off=[0 for x in range(9)]
  hvent_disable=[[0 for x in range(9)] for x in range(24)]
  hvent_disablelowtemp=[[0 for x in range(9)] for x in range(24)]
  hvent_lowtemp=[0 for x in range(9)]
  mhumidifier_off=[0 for x in range(9)]
  mhumidity_max=[0 for x in range(9)]
  mhumidity_min=[0 for x in range(9)]
  mhumidifier_on=[0 for x in range(9)]
  mtemperature_max=[0 for x in range(9)]
  mheater_off=[0 for x in range(9)]
  mheater_on=[0 for x in range(9)]
  mtemperature_min=[0 for x in range(9)]
  mheater_disable=[[0 for x in range(9)] for y in range(24)]
  mlight_off1=[0 for x in range(9)]
  mlight_off2=[0 for x in range(9)]
  mlight_on1=[0 for x in range(9)]
  mlight_on2=[0 for x in range(9)]
  mvent_on=[0 for x in range(9)]
  mvent_off=[0 for x in range(9)]
  mvent_disable=[[0 for x in range(9)] for x in range(24)]
  mvent_disablelowtemp=[[0 for x in range(9)] for x in range(24)]
  mvent_lowtemp=[0 for x in range(9)]
  try:
    with open(conffile) as f:
      envir_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(envir_config))
    gasconcentrate_max[channel]=int(config.get(C,'gasconcentrate_max'))
    hhumidifier_off[channel]=int(config.get(H,'humidifier_off'))
    hhumidity_max[channel]=int(config.get(H,'humidity_max'))
    hhumidity_min[channel]=int(config.get(H,'humidity_min'))
    hhumidifier_on[channel]=int(config.get(H,'humidifier_on'))
    htemperature_max[channel]=int(config.get(H,'temperature_max'))
    hheater_off[channel]=int(config.get(H,'heater_off'))
    hheater_on[channel]=int(config.get(H,'heater_on'))
    htemperature_min[channel]=int(config.get(H,'temperature_min'))
    for x in range(24):
      hheater_disable[x][channel]=int(config.get(H,'heater_disable_'+addzero(x)))
    hlight_on1[channel]=int(config.get(H,'light_on1'))
    hlight_off1[channel]=int(config.get(H,'light_off1'))
    hlight_on2[channel]=int(config.get(H,'light_on2'))
    hlight_off2[channel]=int(config.get(H,'light_off2'))
    hvent_on[channel]=int(config.get(H,'vent_on'))
    hvent_off[channel]=int(config.get(H,'vent_off'))
    for x in range(24):
      hvent_disable[x][channel]=int(config.get(H,'vent_disable_'+addzero(x)))
    for x in range(24):
      hvent_disablelowtemp[x][channel]=int(config.get(H,'vent_disablelowtemp_'+addzero(x)))
    hvent_lowtemp[channel]=int(config.get(H,'vent_lowtemp'))
    mhumidifier_off[channel]=int(config.get(M,'humidifier_off'))
    mhumidity_max[channel]=int(config.get(M,'humidity_max'))
    mhumidity_min[channel]=int(config.get(M,'humidity_min'))
    mhumidifier_on[channel]=int(config.get(M,'humidifier_on'))
    mtemperature_max[channel]=int(config.get(M,'temperature_max'))
    mheater_off[channel]=int(config.get(M,'heater_off'))
    mheater_on[channel]=int(config.get(M,'heater_on'))
    mtemperature_min[channel]=int(config.get(M,'temperature_min'))
    for x in range(24):
      mheater_disable[x][channel]=int(config.get(M,'heater_disable_'+addzero(x)))
    mlight_on1[channel]=int(config.get(M,'light_on1'))
    mlight_off1[channel]=int(config.get(M,'light_off1'))
    mlight_on2[channel]=int(config.get(M,'light_on2'))
    mlight_off2[channel]=int(config.get(M,'light_off2'))
    mvent_on[channel]=int(config.get(M,'vent_on'))
    mvent_off[channel]=int(config.get(M,'vent_off'))
    for x in range(24):
      mvent_disable[x][channel]=int(config.get(M,'vent_disable_'+addzero(x)))
    for x in range(24):
      mvent_disablelowtemp[x][channel]=int(config.get(M,'vent_disablelowtemp_'+addzero(x)))
    mvent_lowtemp[channel]=int(config.get(M,'vent_lowtemp'))
    writetodebuglog("i","Environment characteristics is loaded.")
  except:
    writetodebuglog("e","Cannot open "+conffile+"!")
    exit(14)

# create and remove lock file
def lckfile(mode):
  try:
    if mode>0:
      lcf=open(lockfile,'w')
      lcf.close()
      writetodebuglog("i","Creating lockfile.")
    else:
      writetodebuglog("i","Removing lockfile.")
      os.remove(lockfile)
  except:
    writetodebuglog("w","Cannot create/remove"+lockfile+"!")

# write data to log with timestamp
def writelog(channel,temperature,humidity,gasconcentrate,statusdata):
  logfile=dir_log+'/mm8d_ch'+str(channel)+'.log'
  dt=(strftime("%Y-%m-%d,%H:%M",gmtime()))
  lckfile(1)
  writetodebuglog("i","Writing data to log.")
  if not os.path.isfile(logfile):
    f=open(logfile,'w')
    f.close()
  try:
    with open(logfile,"r+") as f:
      first_line=f.readline()
      lines=f.readlines()
      f.seek(0)
      if (channel==0):
        s=dt+','+ \
              statusdata[0]+','+statusdata[1]+','+statusdata[2]+','+ \
              statusdata[3]+','+statusdata[4]+'\n'
      else:
        s=dt+','+ \
              str(temperature)+','+ \
              str(humidity)+','+ \
              str(gasconcentrate)+','+ \
              statusdata[0]+','+statusdata[1]+','+statusdata[2]+','+ \
              statusdata[3]+','+statusdata[4]+','+statusdata[5]+','+ \
              statusdata[6]+','+statusdata[7]+'\n'
      f.write(s)
      f.write(first_line)
      f.writelines(lines)
      f.close()
  except:
    writetodebuglog("e","Cannot write "+logfile+"!")
    lckfile(0)
    exit(15)
  lckfile(0)

# check external control files
def extcont(channel,output,status):
  writetodebuglog("i","Checking override file: "+dir_var+'/'+str(channel)+"/out"+str(output)+".")
  if os.path.isfile(dir_var+'/'+str(channel)+"/out"+str(output)):
    try:
      f=open(dir_var+'/'+str(channel)+"/out"+str(output),'r')
      v=f.read()
      f.close()
      if v=="neutral": s=status
      if v=="off": s="0"
      if v=="on": s="1"
    except:
      s=status
  else:
    s=status
  return s

# blink ACTIVE LED
def blinkactiveled(on):
  return 0

# get external temperature from openweathermap.org
def getexttemp():
  writetodebuglog("i","Get external temperature from internet.")
  response=requests.get(base_url+"appid="+api_key+"&q="+city_name)
  x=response.json()
  if x["cod"]!="404":
    y=x["main"] 
    current_temperature=y["temp"]
    current_temperature=round(current_temperature-273)
    writetodebuglog("i","External temperature: "+str(current_temperature)+" degree Celsius")
    return current_temperature
  else:
    writetodebuglog("w","Cannot get external temperature from internet.")
    return 18

def MM6DGetInputData(channel):
  return 0

def MM6DSetOutputData(channel):
  return 0

def MM7DGetAnalogData(channel):
  return 0

def MM7DSetStatusLED(channel):
  return 0

def MM8DGetInputData(channel):
  return 0

def MM8DSetOutputData(channel):
  return 0

def AnalizeData():
  return 0

def MakeLogFiles():
  return 0

# get version data from controllers
def getcontrollerversion(conttype,channel):
  global mv
  global sv
  mv=0
  sv=0
  rc=0
  blinkactiveled(1);
  if (conttype==6):
    url="http://"+adr_mm6dch[channel]+"/version"
  else:
    url="http://"+adr_mm7dch[channel]+"/version"
  try:
    r=requests.get(url,timeout=3)
    if (r.status_code==200):
      rc=1
      l=0
      for line in r.text.splitlines():
        l=l+1
        if (l==2):
          mv=int(line[0])
          sv=int(line[2])
          break
    else:
      rc=0
  except:
    rc=0
  blinkactiveled(0);
  return rc

# main program
global in_ocprot
global in_opmode
global in_swmanu
global in_alarm
global in_humidity
global in_temperature
global in_gasconcentrate
global out_lamps
global out_vents
global out_heaters
global mainssensor
global mainsbreaker1
global mainsbreaker2
global mainsbreaker3
global relay_alarm
global led_active
global led_warning
global led_error
# reset variables
in_ocprot=[0 for channel in range(9)]
in_opmode=[0 for channel in range(9)]
in_swmanu=[0 for channel in range(9)]
in_alarm=[0 for channel in range(9)]
in_humidity=[0 for channel in range(9)]
in_temperature=[0 for channel in range(9)]
in_gasconcentrate=[0 for channel in range(9)]
out_lamps=[0 for channel in range(9)]
out_vents=[0 for channel in range(9)]
out_heaters=[0 for channel in range(9)]
mainssensor=0
mainsbreaker1=0
mainsbreaker2=0
mainsbreaker3=0
relay_alarm=0
led_active=0
led_warning=0
led_error=0
# load main settings
loadconfiguration(confdir+"mm8d.ini")
# checking version of remote devices
for channel in range(1,9):
  if (ena_ch[channel] > 0):
    if getcontrollerversion(6,channel):
      if (mv*10+sv < COMPMV6*10+COMPSV6):
        ena_ch[channel] = 0;
        writetodebuglog("e","Version of MM6D on channel #"+str(channel)+" is not compatible.")
    else:
      ena_ch[channel] = 0;
      writetodebuglog("e","MM6D on channel #"+str(channel)+" is not accessible.")
for channel in range(1,9):
  if (ena_ch[channel] > 0):
    if getcontrollerversion(7,channel):
      if (mv*10+sv < COMPMV7*10+COMPSV7):
        ena_ch[channel] = 0;
        writetodebuglog("e","Version of MM7D on channel #"+str(channel)+" is not compatible.")
    else:
      ena_ch[channel] = 0;
      writetodebuglog("e","MM7D on channel #"+str(channel)+" is not accessible.")


# check number of enabled channels
#  ii = 0;
#  for (int channel = 0; channel < 8; ++channel) ii = ii + ena_ch[channel];
#  if (ii == 0)
#  {
#    printf(msg(18));
#    exit(2);
#  }


# load environment parameter settings
for x in range(1,9):
  if (ena_ch[x]==1):
    loadenvirchars(x,confdir+"envir-ch"+str(x)+".ini")

exit()

initports()
exttemp=18
writetodebuglog("i","Starting program as daemon.")
with daemon.DaemonContext() as context:
  try:
    time.sleep(1)
    while True:
      # get input data from MM6D controllers
      writetodebuglog("i","Getting input data from MM6Ds.")
      for x in range(1,9):
        if (ena_ch[x]=="1"):
          MM6DGetInputData(x)
      writetodebuglog("i","Getting is done.")
      blinkactled()
      # get analog data from MM7D controllers
      writetodebuglog("i","Getting analog values from MM7Ds.")
      for x in range(1,9):
        if (ena_ch[x]=="1"):
          MM7DGetAnalogData(x)
      writetodebuglog("i","Getting is done.")
      blinkactled()
      # get input data from MM8D controller
      writetodebuglog("i","Getting input data from MM8D.")
      MM8DGetInputData
      writetodebuglog("i","Getting is done.")
      blinkactled()
      # analize data and make logfiles
      AnalizeData()
      MakeLogFiles()
      # set output data to MM6D controllers
      writetodebuglog("i","Setting output data to MM6Ds.")
      for x in range(1,9):
        if (ena_ch[x]=="1"):
          MM6DSetOutputData(x)
      writetodebuglog("i","Setting is done.")
      blinkactled()
      # get analog data from MM7D controllers
      writetodebuglog("i","Setting status LEDs to MM7Ds.")
      for x in range(1,9):
        if (ena_ch[x]=="1"):
          MM7DGetStatusLED(x)
      writetodebuglog("i","Setting is done.")
      blinkactled()
      # set output data to MM8D controller
      writetodebuglog("i","Setting output data to MM8D.")
      MM8DGetInputData
      writetodebuglog("i","Setting is done.")
      blinkactled()
      # wait 10s
      writetodebuglog("i","Waiting 10 s.")
      time.sleep(10)
  except KeyboardInterrupt:
    GPIO.cleanup
exit(0)
