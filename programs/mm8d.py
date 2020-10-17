#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.1 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>            |
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

# initializing ports
def initports():
  writetodebuglog("i","Initializing I/O ports.")
  if (hw == 0):
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(prt_in0,GPIO.IN)
    GPIO.setup(prt_in1,GPIO.IN)
    GPIO.setup(prt_in2,GPIO.IN)
    GPIO.setup(prt_in3,GPIO.IN)
    GPIO.setup(prt_in4,GPIO.IN)
    GPIO.setup(prt_in5,GPIO.IN)
    GPIO.setup(prt_in6,GPIO.IN)
    GPIO.setup(prt_in7,GPIO.IN)
    GPIO.setup(prt_out0,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out1,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out2,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out3,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out4,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out5,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out6,GPIO.OUT,initial=GPIO.LOW)
    GPIO.setup(prt_out7,GPIO.OUT,initial=GPIO.LOW)
  else:
    portio.outb(0,lpt_adr)

# write a line to debug logfile
def writetodebuglog(level,text):
  if dbg_log=="1":
    if level=="i":
      lv="INFO   "
    if level=="w":
      lv="WARNING"
    if level=="e":
      lv="ERROR  "
    debugfile=dir_log+time.strftime("debug-%Y%m%d.log")
    dt=(strftime("%Y-%m-%d %H:%M:%S", gmtime()))
    try:
      with open(debugfile, "a") as d:
        d.write(dt+'  '+lv+' '+text+'\n')
        d.close()
    except:
      print ("")

# load configuration
def loadconfiguration(conffile):
  global address
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
  global lpt_adr
  global prt_in
  global prt_out
  global usr_uid
  try:
    with open(conffile) as f:
      mainconfig=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mainconfig))
    address=config.get('e-mail','address')
    adr_mm6dch=[0 for x in range(17)]
    for i in range(1,17):
      adr_mm6dch[i]=config.get('MM6D','adr_mm6dch'+addzero(i))
    adr_mm7dch=[0 for x in range(17)]
    for i in range(1,17):
      adr_mm7dch[i]=config.get('MM7D','adr_mm7dch'+addzero(i))
    api_key=config.get('openweathermap.org','api_key')
    base_url=config.get('openweathermap.org','base_url')
    city_name=config.get('openweathermap.org','city_name')
    dbg_log='0'
    dbg_log=config.get('log','dbg_log')
    dir_log=config.get('directories','dir_log')
    dir_var=config.get('directories','dir_var')
    ena_ch=[0 for x in range(17)]
    for i in range(1,17):
      ena_ch[i]=int(config.get('enable','ena_ch'+addzero(i)))
    lockfile=config.get('directories','dir_lck')+'mm8d.lck'
    lpt_adr=int(config.get('LPTport','lpt_adr'))
    prt_in=[0 for x in range(8)]
    for i in range(8):
      prt_in[i]=int(config.get('GPIOports','prt_in'+str(i)))
    prt_out=[0 for x in range(8)]
    for i in range(8):
      prt_out[i]=int(config.get('GPIOports','prt_out'+str(i)))
    usr_uid=config.get('user','usr_uid')
    writetodebuglog("i","Configuration is loaded.")
  except:
    writetodebuglog("e","Cannot open "+conffile+"!")
    exit(1)

# add a zero char
def addzero(num):
  if num<10:
    z="0"
  else:
    z=""
  s=z+str(num)
  return s

# load environment characteristics
def loadenvirchars(channel,conffile):
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
  H="hyphae"
  M="mushroom"
  hheater_disable=[[0 for x in range(24)] for x in range(17)]
  hheater_off=[0 for x in range(17)]
  hheater_on=[0 for x in range(17)]
  hhumidifier_disable=[[0 for x in range(24)] for x in range(17)]
  hhumidifier_off=[0 for x in range(17)]
  hhumidifier_on=[0 for x in range(17)]
  hhumidity_max=[0 for x in range(17)]
  hhumidity_min=[0 for x in range(17)]
  hlight_off1=[0 for x in range(17)]
  hlight_off2=[0 for x in range(17)]
  hlight_on1=[0 for x in range(17)]
  hlight_on2=[0 for x in range(17)]
  htemperature_max=[0 for x in range(17)]
  htemperature_min=[0 for x in range(17)]
  hvent_disable=[[0 for x in range(24)] for x in range(17)]
  hvent_disablelowtemp=[[0 for x in range(24)] for x in range(17)]
  hvent_lowtemp=[0 for x in range(17)]
  hvent_off=[0 for x in range(17)]
  hvent_on=[0 for x in range(17)]
  mheater_disable=[[0 for x in range(24)] for x in range(17)]
  mheater_off=[0 for x in range(17)]
  mheater_on=[0 for x in range(17)]
  mhumidifier_disable=[[0 for x in range(24)] for x in range(17)]
  mhumidifier_off=[0 for x in range(17)]
  humidifier_on=[0 for x in range(17)]
  mhumidity_max=[0 for x in range(17)]
  mhumidity_min=[0 for x in range(17)]
  mlight_off1=[0 for x in range(17)]
  mlight_off2=[0 for x in range(17)]
  mlight_on1=[0 for x in range(17)]
  mlight_on2=[0 for x in range(17)]
  mtemperature_max=[0 for x in range(17)]
  mtemperature_min=[0 for x in range(17)]
  mvent_disable=[[0 for x in range(24)] for x in range(17)]
  mvent_disablelowtemp=[[0 for x in range(24)] for x in range(17)]
  mvent_lowtemp=[0 for x in range(17)]
  mvent_off=[0 for x in range(17)]
  mvent_on=[0 for x in range(17)]
  try:
    with open(conffile) as f:
      envir_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(envir_config))
#    for x in range(24):
#      hhumidifier_disable[x][channel]=int(config.get(H,'humidifier_disable_'+addzero(x)))
#    for x in range(24):
#      hheater_disable[x][channel]=int(config.get(H,'heater_disable_'+addzero(x)))
#    for x in range(24):
#      hvent_disable[x][channel]=int(config.get(H,'vent_disable_'+addzero(x)))
#    for x in range(24):
#      hvent_disablelowtemp[x][channel]=int(config.get(H,'vent_disablelowtemp_'+addzero(x)))
    hheater_off[channel]=int(config.get(H,'heater_off'))
    hheater_on[channel]=int(config.get(H,'heater_on'))
    hhumidifier_off[channel]=int(config.get(H,'humidifier_off'))
    hhumidifier_on[channel]=int(config.get(H,'humidifier_on'))
    hhumidity_max[channel]=int(config.get(H,'humidity_max'))
    hhumidity_min[channel]=int(config.get(H,'humidity_min'))
    hlight_off1[channel]=int(config.get(H,'light_off1'))
    hlight_off2[channel]=int(config.get(H,'light_off2'))
    hlight_on1[channel]=int(config.get(H,'light_on1'))
    hlight_on2[channel]=int(config.get(H,'light_on2'))
    htemperature_max[channel]=int(config.get(H,'temperature_max'))
    htemperature_min[channel]=int(config.get(H,'temperature_min'))
    hvent_lowtemp[channel]=int(config.get(H,'vent_lowtemp'))
    hvent_off[channel]=int(config.get(H,'vent_off'))
    hvent_on[channel]=int(config.get(H,'vent_on'))
#    for x in range(24):
#      mhumidifier_disable[x][channel]=int(config.get(M,'humidifier_disable_'+addzero(x)))
#    for x in range(24):
#      mheater_disable[x][channel]=int(config.get(M,'heater_disable_'+addzero(x)))
#    for x in range(24):
#      mvent_disable[x][channel]=int(config.get(M,'vent_disable_'+addzero(x)))
#    for x in range(24):
#      mvent_disablelowtemp[x][channel]=int(config.get(M,'vent_disablelowtemp_'+addzero(x)))
    mheater_off[channel]=int(config.get(M,'heater_off'))
    mheater_on[channel]=int(config.get(M,'heater_on'))
#    mhumidifier_off[channel]=int(config.get(M,'humidifier_off'))
#    mhumidifier_on[channel]=int(config.get(M,'humidifier_on'))
#    mhumidity_max[channel]=int(config.get(M,'humidity_max'))
#    mhumidity_min[channel]=int(config.get(M,'humidity_min'))
    mlight_off1[channel]=int(config.get(M,'light_off1'))
    mlight_off2[channel]=int(config.get(M,'light_off2'))
    mlight_on1[channel]=int(config.get(M,'light_on1'))
    mlight_on2[channel]=int(config.get(M,'light_on2'))
    mtemperature_max[channel]=int(config.get(M,'temperature_max'))
    mtemperature_min[channel]=int(config.get(M,'temperature_min'))
    mvent_lowtemp[channel]=int(config.get(M,'vent_lowtemp'))
    mvent_off[channel]=int(config.get(M,'vent_off'))
    mvent_on[channel]=int(config.get(M,'vent_on'))
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
  logfile=dir_log+'mm8d_ch'+addzero(channel)+'.log'
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
              statusdata[3]+','+statusdata[4]+','+statusdata[5]+'\n'
      else:
        s=dt+','+ \
              str(temperature)+','+ \
              str(humidity)+','+ \
              str(gasconcentrate)+','+ \
              statusdata[0]+','+statusdata[1]+','+statusdata[2]+','+ \
              statusdata[3]+','+statusdata[4]+','+statusdata[5]+','+ \
              statusdata[6]+','+statusdata[7]+','+statusdata[8]+','+ \
              statusdata[9]+'\n'
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
  writetodebuglog("i","Checking override file: "+dir_var+addzero(channel)+"/out"+str(output)+".")
  if os.path.isfile(dir_var+addzero(channel)+"/out"+str(output)):
    try:
      f=open(dir_var+addzero(channel)+"/out"+str(output),'r')
      v=f.read()
      f.close()
      if v == "neutral": s=status
      if v == "off": s="0"
      if v == "on": s="1"
    except:
      s=status
  else:
    s=status
  return s

# blink ACTIVE LED
def blinkactled():
  GPIO.output(prt_act,1)
  time.sleep(0.5)
  GPIO.output(prt_act,0)
  time.sleep(0.5)

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

# main program
global prevtemperature
global prevhumidity
global prevgasconcentrate
global prevmm6dinputs
global prevmm6doutputs
global prevmm8dinputs
global prevmm8doutputs
#confdir="/etc/mm8d/"
confdir="/usr/local/etc/mm8d/"
loadconfiguration(confdir+"mm8d.ini")
for x in range(1,17):
  if (ena_ch[x]==1):
    loadenvirchars(x,confdir+"envir-ch"+addzero(x)+".ini")
initports()
first=1
exttemp=18
prevtemperature=[0 for x in range(17)]
prevhumidity=[0 for x in range(17)]
prevgasconcentrate=[0 for x in range(17)]
prevmm6dinputs=["" for x in range(17)]
prevmm6doutputs=["" for x in range(17)]
prevmm8dinputs=""
prevmm8doutputs=""
writetodebuglog("i","Starting program as daemon.")
with daemon.DaemonContext() as context:
  try:
    time.sleep(1)
    while True:
      # get input data from MM6D controllers
      writetodebuglog("i","Getting input data from MM6Ds.")
      for x in range(1,17):
        if (ena_ch[x]=="1"):
          MM6DGetInputData(x)
      writetodebuglog("i","Getting is done.")
      blinkactled()
      # get analog data from MM7D controllers
      writetodebuglog("i","Getting analog values from MM7Ds.")
      for x in range(1,17):
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
      for x in range(1,17):
        if (ena_ch[x]=="1"):
          MM6DSetOutputData(x)
      writetodebuglog("i","Setting is done.")
      blinkactled()
      # get analog data from MM7D controllers
      writetodebuglog("i","Setting status LEDs to MM7Ds.")
      for x in range(1,17):
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
