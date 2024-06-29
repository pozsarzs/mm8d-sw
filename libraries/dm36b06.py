# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | dm36b06.py                                                                 |
# | Display handler module                                                     |
# +----------------------------------------------------------------------------+
#
#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

import serial
import time 
from pymodbus.client import ModbusSerialClient

global buffer
global baudrate
global method
global port

# default
port = '/dev/ttyS0'
baudrate = 9600
method = 'rtu'
buffer = [0 for x in range(6)]
blink = [0 for x in range(6)]

# clear display
def cleardisplay(modbusid):
  return cleardigits(modbusid, [1,1,1,1,1,1])

# clear digits
def cleardigits(modbusid, digits):
  b = [0 for x in range(6)]
  for i in range(6):
    if digits[i] > 0:
      b[i] = 32
  return writedigits(modbusid, b)

# blink display
def blinkdisplay(modbusid):
  return blinkdigits(modbusid, [1,1,1,1,1,1])

# no blink display
def noblinkdisplay(modbusid):
  return blinkdigits(modbusid, [0,0,0,0,0,0])

def blinkdigits(modbusid, digits):
# blink digits
  blink = [0 for x in range(6)]
  data = 0
  for i in range(6):
    if digits[i] > 0:
      blink[i] = 1
  for i in range(6):
    data = data + blink[5 - i] * (2 ** i)
    print(data)
  rc = 1
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_registers(8, data, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# write digits
def writedigits(modbusid, digits):
  buffer = [0 for x in range(6)]
  for i in range(6):
    buffer[i] = digits[i]
  rc = 1
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_registers(0, buffer, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# write text
def writestr(modbusid, text):
  b = [0 for i in range(6)]
  try:
    for i in range(6):
      b[i] = ord(text[i])
  except:
      print() 
  return writedigits(modbusid, b)
  
# write integer
def writeint(modbusid, number):
  rc = 1
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(7, number, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set brightness
def setbrightness(modbusid, brightness):
  # brightness: 1-8
  rc = 1
  if brightness > 8:
    brightness = 8
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(9, brightness, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set Modbus ID
def setmodbusid(modbusid, newid):
  # ID: 1-247 
  rc = 1
  if newid < 1 :
    newid = 1
  if newid > 247 :
    newid = 247
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(253, newid, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set baudrate
def setbaudrate(modbusid, newbaudrate):
  # 0: 1200
  # 1: 2400
  # 2: 4800
  # 3: 9600
  # 4: 19200
  # 5: 38400
  # 6: 57600
  # 7: 115200
  rc = 1
  if newbaudrate < 1 :
    newbaudrate = 1
  if newbaudrate > 7 :
    newbaudrate = 7
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(254, newbaudrate, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set parity
def setparity(modbusid, newparity):
  # 0: none
  # 1: even
  # 2: odd
  rc = 1
  if newparity < 0 :
    newparity = 0
  if newparity > 2 :
    newparity = 2
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(255, newparity, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# factory reset
def factoryreset(modbusid):
  rc = 1
  try:
    mb_client = ModbusSerialClient(method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(251, 0, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

