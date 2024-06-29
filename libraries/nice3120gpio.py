# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | nice3120gpio.py                                                            |
# | GPIO port handler for NEXCOM NICE 3120 industrial PC                       |
# +----------------------------------------------------------------------------+
#
#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# D-10 GPIO connector (JP1):    |  LEDs on the front panel:
#   Size: 2x5 pin header        |    Address: 802H
#   Pinout:                     |    Bit0:    Status LED  blue
#     1: GP27 IN   2: GP23 OUT  |    Bit1:    Alarm LED   red
#     3: GP26 IN   4: GP22 OUT  |    Bit2:    -
#     5: GP25 IN   6: GP21 OUT  |    Bit3:    -
#     7: GP24 IN   8: GP20 OUT  |    Bit4:    -
#     9: +5 V     10: GND       |    Bit5:    -
#                               |    Bit6:    -
# Bits:                         |    Bit7:    -                  
#   Address: 801H               |
#   Bit0:    GP20  output       |
#   Bit1:    GP21  output       |
#   Bit2:    GP22  output       |
#   Bit3:    GP23  output       |
#   Bit4:    GP24  input        |
#   Bit5:    GP25  input        |
#   Bit6:    GP26  input        |
#   Bit7:    GP27  input        |

import portio

global baseaddress
global bits
global maskread
global offsetgpio
global offsetleds

# default
baseaddress = 0x800
maskread = 0x0f
offsetgpio = 1
offsetleds = 2

# set access to hardware
def setup():
 return not portio.ioperm(baseaddress, 3, 1)

# read inputs  
def input(n):
  bits = [0 for x in range(8)]
  # valid gpio port number
  try:
    if (n >= 20) and (n <= 27):
      # read original data
      i = portio.inb(baseaddress + offsetgpio)
      # store to array
      for j in range(8):
        if i & (2 ** j) > 1:
          bits[j] = 1
      # set outgpio
      return bits[n - 20]
    else:
      return 0
  except:
    return 0

# write outputs  
def output(n, d):
  bits = [0 for x in range(8)]
  # valid input data
  if d < 1:
    d = 0          
  if d > 1:
    d = 1
  # valid gpio port number
  try:
    if (n >= 20) and (n <= 23):
      # read original data and masking upper four bits
      i = portio.inb(baseaddress + offsetgpio) & maskread
      # store to array
      for j in range(8):
        if i & (2 ** j) > 1:
          bits[j] = 1
      # set outgpio
      bits[n - 20] = d
      # write new data
      i = 0
      for j in range(8):
        i = i + (bits[j] * (2 ** j))
      portio.outb(i, baseaddress + offsetgpio) 
      # write check
      if portio.inb(baseaddress + offsetgpio) & maskread == i:
        return 1
      else:
        return 0
    else:
      return 0
  except:
    return 0

# write LED outputs  
def leds(n, d):
  bits = [0 for x in range(8)]
  # valid input data
  if d < 1:
    d = 0          
  if d > 1:
    d = 1
  # valid gpio port number
  try:
    if (n >= 0) and (n <= 1):
      # read original data and masking upper four bits
      i = portio.inb(baseaddress + offsetleds) & maskread
      # store to array
      for j in range(8):
        if i & (2 ** j) > 1:
          bits[j] = 1
      # set outgpio
      bits[n] = d
      # write new data
      i = 0
      for j in range(8):
        i = i + (bits[j] * (2 ** j))
      portio.outb(i, baseaddress + offsetleds) 
      # write check
      if portio.inb(baseaddress + offsetleds) & maskread == i:
        return 1
      else:
        return 0
    else:
      return 0
  except:
    return 0

