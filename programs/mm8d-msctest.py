#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.4 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2022 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | mm8d-msctest.py                                                            |
# | Mini serial console test program                                           |
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
import io
import os
import serial
import sys
import time

USRLOCALDIR = 1
if (USRLOCALDIR == 1):
  conffile = '/usr/local/etc/mm8d/mm8d.ini'
else:
  conffile = '/etc/mm8d/mm8d.ini'

# write a debug log line to serial port
def writedebuglogtocomport(level,text):
  if com_enable == "1":
    dt = (strftime("%y%m%d %H%M%S",localtime()))
    try:
      com.open
      com.write(str.encode(dt + ' ' + str.upper(level) + ' ' + text + eol))
      com.close
    except:
      print("")

# send channels' data to display via serial port
def writechannelstatustocomport(channel):
  transmitbuffer = [0x00 for x in range(13)]
  line = ""
  if com_enable == "1":
    if channel == 0:
      transmitbuffer[0x00] = ord("C")
      transmitbuffer[0x01] = ord("H")
      transmitbuffer[0x02] = channel
      transmitbuffer[0x03] = mainsbreakers
      transmitbuffer[0x04] = waterpressurelow
      transmitbuffer[0x05] = waterpressurehigh
      transmitbuffer[0x06] = exttemp
      transmitbuffer[0x07] = relay_tube1
      transmitbuffer[0x08] = relay_tube2
      transmitbuffer[0x09] = relay_tube3
      transmitbuffer[0x0A] = 0x0F
      transmitbuffer[0x0B] = 0x0F
      transmitbuffer[0x0C] = 0x0F
      if override[channel][0] == "on":
        transmitbuffer[0x07] = 0x03
      if override[channel][0] == "off":
        transmitbuffer[0x07] = 0x02
      if override[channel][1] == "on":
        transmitbuffer[0x08] = 0x03
      if override[channel][1] == "off":
        transmitbuffer[0x08] = 0x02
      if override[channel][2] == "on":
          transmitbuffer[0x09] = 0x03
      if override[channel][2] == "off":
          transmitbuffer[0x09] = 0x02
    else:
      transmitbuffer[0x00] = ord("C")
      transmitbuffer[0x01] = ord("H")
      transmitbuffer[0x02] = channel
      transmitbuffer[0x03] = in_temperature[channel]
      transmitbuffer[0x04] = in_humidity
      transmitbuffer[0x05] = in_gasconcentrate
      transmitbuffer[0x06] = in_opmode
      transmitbuffer[0x07] = in_swmanu
      transmitbuffer[0x08] = in_ocprot
      transmitbuffer[0x09] = in_alarm[channel]
      transmitbuffer[0x0A] = out_lamps[channel]
      transmitbuffer[0x0B] = out_vents[channel]
      transmitbuffer[0x0C] = out_heaters[channel]
      if override[channel][0] == "on":
        transmitbuffer[0x0A] = 0x03
      if override[channel][0] == "off":
        transmitbuffer[0x0A] = 0x02
      if override[channel][1] == "on":
        transmitbuffer[0x0B] = 0x03
      if override[channel][1] == "off":
        transmitbuffer[0x0B] = 0x02
      if override[channel][2] == "on":
          transmitbuffer[0x0C] = 0x03
      if override[channel][2] == "off":
          transmitbuffer[0x0C] = 0x02
      if ena_ch[channel] == 0:
        transmitbuffer[0x06] = 0xFF
  for x in range(0,13):
    line = line + chr(transmitbuffer[x]+70)
  try:
    com.open
    com.write(str.encode(line + eol))
    com.close
  except:
    print("")

# load configuration
def loadconfiguration(conffile):
  global com
  global com_device
  global com_speed
  global com_enable
  com_enable = "1"
  try:
    with open(conffile) as f:
      mm8d_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mm8d_config))
    com_device=config.get('COMport','com_device')
    com_speed=int(config.get('COMport','com_speed'))
  except:
    print("ERROR #1: Cannot open configuration file!");
    sys.exit(1);

# main function
global channel
global eol
global exttemp
global mainsbreakers
global override
global ovrstatus
global relay_tube1
global relay_tube2
global relay_tube3
global waterpressurehigh
global waterpressurelow
eol = "\r"
channel = 0
exttemp = 23
mainsbreakers = 0
override = [[0 for x in range(9)] for x in range(3)]
ovrstatus = ["neutral","off","on"]
relay_tube1 = 0
relay_tube2 = 0
relay_tube3 = 0
waterpressurehigh = 0
waterpressurelow = 0

print("\nMM8D Mini serial console test utility * (C) 2020-2022 Pozsar Zsolt")
print("--------------------------------------------------------------------")
#if os.getuid():
#  print(" * You need to be root!")
#  sys.exit(0)
print(" * load configuration: %s..." % conffile)
loadconfiguration(conffile)
print(" * setting ports...")
com = serial.Serial(com_device, com_speed)

while True:
  print(" * What do you like?")
  menuitem = input(" \
   1: Set parameters of the Channel #0\n \
   2: Set parameters of the Channel #1-8\n \
   q: Quit\n")
  if menuitem is "Q" or menuitem is "q":
    break;
  if menuitem is "1":
    channel = 0
    while True:
      print(" * Set variables of the Channel #0")
      print("      channel             ",channel)
      print("   1: mainsbreakers       ",mainsbreakers)
      print("   2: waterpressurelow    ",waterpressurelow)
      print("   3: waterpressurehigh   ",waterpressurehigh)
      print("   4: exttemp             ",exttemp)
      print("   5: relay_tube1         ",relay_tube1)
      print("   6: relay_tube2         ",relay_tube2)
      print("   7: relay_tube3         ",relay_tube3)
      print("   8: override[0][0]      ",ovrstatus[override[0][0]])
      print("   9: override[0][1]      ",override[0][1])
      print("   a: override[0][2]      ",override[0][2])
      print("   q: Back to main menu")
      submenuitem = input()
      if submenuitem is "Q" or submenuitem is "q":
        break
      if submenuitem is "1":
        mainsbreakers = int(not mainsbreakers)
      if submenuitem is "2":
        waterpressurelow= int(not waterpressurelow)
      if submenuitem is "3":
        waterpressurehigh= int(not waterpressurehigh)
      if submenuitem is "4":
        exttemp =int(input("Enter new value: "))
      if submenuitem is "5":
         relay_tube1= int(not relay_tube1)
      if submenuitem is "6":
         relay_tube2= int(not relay_tube2)
      if submenuitem is "7":
         relay_tube3= int(not relay_tube3)
      if submenuitem is "8":
        override[0][0] = override[0][0] + 1
        if override[0][0] == 3:
          override[0][0] = 0
      if submenuitem is "9":
        override[0][1] = override[0][1] + 1
        if override[0][1] == 3:
          override[0][1] = 0
      if submenuitem is "a":
        override[0][2] = override[0][2] + 1
        if override[0][2] == 3:
          override[0][2] = 0
      writechannelstatustocomport(channel)




sys.exit(0)


#      if submenuitem is "1":
#        = int(not )
