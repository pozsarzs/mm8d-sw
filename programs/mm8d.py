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
  try:
    with open(conffile) as f:
      mainconfig=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mainconfig))
    address=config.get('e-mail','api_key')
    api_key=config.get('openweathermap.org','api_key')
    base_url=config.get('openweathermap.org','base_url')
    city_name=config.get('openweathermap.org','city_name')
    dbg_log='0'
    dbg_log=config.get('log','dbg_log')
    dir_log=config.get('directories','dir_log')
    dir_var=config.get('directories','dir_var')
    ena_ch=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
    for i in range(16):
      ena_ch[i]=int(config.get('enable','ena_ch_'+addzero(i)))
    lockfile=config.get('directories','dir_lck')+'mm8d.lck'
    lpt_prt=config.get('LPTPort','lpt_adr')
    prt_in=[0,0,0,0,0,0,0,0,]
    for i in range(8):
      prt_in[i]=int(config.get('GPIOPorts','prt_in_'+addzero(i)))
    prt_out=[0,0,0,0,0,0,0,0,]
    for i in range(8):
      prt_out[i]=int(config.get('GPIOPorts','prt_out_'+addzero(i)))
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
# def loadenvirchars(channel,conffile):

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
  logfile=dir_log+'mm8d_ch'addzero(channel)+'.log'
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
        s=dt+','+
              statusdata[0]+','+statusdata[1]+','+statusdata[2]+','+
              statusdata[3]+','+statusdata[4]+','+statusdata[5]+'\n'
      else:
        s=dt+','+
              str(temperature)+','+
              str(humidity)+','+
              str(gasconcentrate)+','+
              statusdata[0]+','+statusdata[1]+','+statusdata[2]+','+
              statusdata[3]+','+statusdata[4]+','+statusdata[5]+','+
              statusdata[6]+','+statusdata[7]+','+statusdata[8]+','+
              statusdata[9]+'\n'
      f.write(s)
      f.write(first_line)
      f.writelines(lines)
      f.close()
  except:
    writetodebuglog("e","Cannot write "+logfile+"!")
    lckfile(0)
    exit(3)
  lckfile(0)





exit(0)
