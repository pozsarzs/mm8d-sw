#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | mm8d-hwtest.py                                                             |
# | Hardware test program                                                      |
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
#  17: cannot access i/o port

import configparser
import io
import os
import platform
import serial
import sys
import time

# constants
arch=platform.machine()
if arch.find("86") > -1:
  HW = 1
  import portio
else:
  HW = 0
  import RPi.GPIO as GPIO

USRLOCALDIR = 1
if (USRLOCALDIR == 1):
  CONFFILE = '/usr/local/etc/mm8d/mm8d.ini'
else:
  CONFFILE = '/etc/mm8d/mm8d.ini'

global EOL
global LPTADDRESSES
EOL = "\r"
LPTADDRESSES = [0x378,0x278,0x3bc]

# load configuration
def loadconfiguration(CONFFILE):
  global com
  global prt_com
  global com_speed
  C = 'COMport'
  G = 'GPIOport'
  L = 'LPTport'
  if HW == 0:
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
  try:
    with open(CONFFILE) as f:
      mm8d_config = f.read()
    config = configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mm8d_config))
    # number of the used GPIO ports
    if HW == 0:
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
      prt_lpt = int(config.get(L,'prt_lpt'))
      if (prt_lpt < 0) or (prt_lpt > 2):
        prt_lpt = 0
    # port name
    prt_com = config.get(C,'prt_com')
    # port speed
    com_speed = 9600
    com_speed = int(config.get(C,'com_speed'))
  except:
    print("ERROR #1: Cannot open configuration file!");
    sys.exit(1);

# main function
print("\nMM8D hardware test utility * (C) 2020-2023 Pozsar Zsolt")
print("-------------------------------------------------------")
if os.getuid():
  print(" * You need to be root!")
  sys.exit(0)
print(" * load configuration: %s..." % CONFFILE)
loadconfiguration(CONFFILE)
print(" * setting ports...")
com = serial.Serial(prt_com, com_speed)
if HW == 0:
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
  status = portio.ioperm(LPTADDRESSES[prt_lpt],1,1)
  if status:
    print("ERROR #17: Cannot access I/O port:",hex(LPTADDRESSES[prt_lpt]));
    sys.exit(17)
  status = portio.ioperm(LPTADDRESSES[prt_lpt] + 1, 1, 1)
  if status:
    print("ERROR #17: Cannot access I/O port:",hex(LPTADDRESSES[prt_lpt] + 1));
    sys.exit(17)
  portio.outb(0,LPTADDRESSES[prt_lpt])

while True:
  print(" * What do you like?")
  selection = input(" \
   1: Check I1-4 inputs\n \
   2: Check RO1-4 relay contact outputs\n \
   3: Check LO1-4 open collector outputs\n \
   4: Write text to the mini serial console\n \
   q: Quit\n")
  if selection is "Q" or selection is "q":
    print(" * Quitting.")
    if HW == 0:
      GPIO.cleanup()
    else:
      portio.outb(0,LPTADDRESSES[prt_lpt])
    sys.exit(0)

  if selection is "1":
    print(" * Check I1-4 inputs")
    if HW == 0:
      print("   used GPIO ports:")
      print("     I1: GPIO", prt_i1,sep = '')
      print("     I2: GPIO", prt_i2,sep = '')
      print("     I3: GPIO", prt_i3,sep = '')
      print("     I4: GPIO", prt_i4,sep = '')
      print("   Press ^C to stop!")
      try:
        while True:
          s = ""
          if GPIO.input(prt_i4):
            s = "1"
          else:
            s = "0"
          if GPIO.input(prt_i3):
            s = s + "1"
          else:
            s = s + "0"
          if GPIO.input(prt_i2):
            s = s + "1"
          else:
            s = s + "0"
          if GPIO.input(prt_i1):
            s = s + "1"
          else:
            s = s + "0"
          print(s)
          time.sleep(1)
      except KeyboardInterrupt:
        print()
    else:
      print("   used lines of LPT port:")
      print('     LPT #',prt_lpt + 1,sep = '')
      print("     I1: -ERROR")
      print("     I2: SELECT")
      print("     I3: PE")
      print("     I4: -ACKNOLEDGE")
      print("   Press ^C to stop!")
      try:
        while True:
          indata = portio.inb(LPTADDRESSES[prt_lpt] + 1)
          indata = indata << 1
          indata = indata >> 4
          print("    ",format(indata,'04b'))
          time.sleep(1)
      except KeyboardInterrupt:
        print()

  if selection is "2":
    print(" * Check RO1-4 relay contact outputs")
    if HW == 0:
      print("   used GPIO ports:")
      print("     RO1: GPIO", prt_ro1,sep = '')
      print("     RO2: GPIO", prt_ro2,sep = '')
      print("     RO3: GPIO", prt_ro3,sep = '')
      print("     RO4: GPIO", prt_ro4,sep = '')
      print("   Press ^C to stop!")
      try:
        while True:
          GPIO.output(prt_ro1,1)
          time.sleep(1)
          GPIO.output(prt_ro1,0)
          GPIO.output(prt_ro2,1)
          time.sleep(1)
          GPIO.output(prt_ro2,0)
          GPIO.output(prt_ro3,1)
          time.sleep(1)
          GPIO.output(prt_ro3,0)
          GPIO.output(prt_ro4,1)
          time.sleep(1)
          GPIO.output(prt_ro4,0)
      except KeyboardInterrupt:
        GPIO.output(prt_ro1,0)
        GPIO.output(prt_ro2,0)
        GPIO.output(prt_ro3,0)
        GPIO.output(prt_ro4,0)
        print()
    else:
      print("   used lines of LPT port:")
      print('     LPT #',prt_lpt + 1,sep = '')
      print("     RO1: D0")
      print("     RO2: D1")
      print("     RO3: D2")
      print("     RO4: D3")
      print("   Press ^C to stop!")
      try:
        while True:
          portio.outb(1,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(2,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(4,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(8,LPTADDRESSES[prt_lpt])
          time.sleep(1)
      except KeyboardInterrupt:
          portio.outb(0,LPTADDRESSES[prt_lpt])
          print()

  if selection is "3":
    print(" * Check LO1-4 open collector outputs")
    if HW == 0:
      print("   used GPIO ports:")
      print("     LO1: GPIO", prt_lo1,sep = '')
      print("     LO2: GPIO", prt_lo2,sep = '')
      print("     LO3: GPIO", prt_lo3,sep = '')
      print("     LO4: GPIO", prt_lo4,sep = '')
      print("   Press ^C to stop!")
      try:
        while True:
          GPIO.output(prt_lo1,1)
          time.sleep(1)
          GPIO.output(prt_lo1,0)
          GPIO.output(prt_lo2,1)
          time.sleep(1)
          GPIO.output(prt_lo2,0)
          GPIO.output(prt_lo3,1)
          time.sleep(1)
          GPIO.output(prt_lo3,0)
          GPIO.output(prt_lo4,1)
          time.sleep(1)
          GPIO.output(prt_lo4,0)
      except KeyboardInterrupt:
        GPIO.output(prt_lo1,0)
        GPIO.output(prt_lo2,0)
        GPIO.output(prt_lo3,0)
        GPIO.output(prt_lo4,0)
        print()
    else:
      print("   used lines of LPT port:")
      print('     LPT #',prt_lpt + 1,sep = '')
      print("     LO1: D4")
      print("     LO2: D5")
      print("     LO3: D6")
      print("     LO4: D7")
      print("   Press ^C to stop!")
      try:
        while True:
          portio.outb(16,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(32,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(64,LPTADDRESSES[prt_lpt])
          time.sleep(1)
          portio.outb(128,LPTADDRESSES[prt_lpt])
          time.sleep(1)
      except KeyboardInterrupt:
          portio.outb(0,LPTADDRESSES[prt_lpt])
          print()

  if selection is "4":
    print(" * Write text to the mini serial console")
    print("   used COM port:")
    print("     device: ", prt_com)
    print("     speed:  ", com_speed)
    print("   Press ^C to stop!")
    try:
      while True:
        com.open
        com.write(str.encode(input() + EOL))
        com.close
    except KeyboardInterrupt:
        print()

sys.exit(0)
