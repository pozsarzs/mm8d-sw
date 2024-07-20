# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | dt510.py                                                                   |
# | Consumption meter handler module                                           |
# +----------------------------------------------------------------------------+
#
#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

import numpy as np
import serial
import time 
from pymodbus.client import ModbusSerialClient

global baudrate
global databits
global method
global parity
global port
global current_transformer

# default
baudrate = 9600
bytesize = 7
method = 'ascii'
parity = 'E'
port = '/dev/ttyS0'
current_transformer = 10

#read all register
def readregisters(modbusid):
  global mb_result
  rc = 1
  try:
    mb_reg = 100
    mb_regs = 13
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_result = mb_client.read_holding_registers(mb_reg, mb_regs, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# P/Q/S: active/reactive/apparant power
def pqs(raw):
  # 32767 = 3000 W/VAr/VA
  return ((raw * 3000) / 32767) * current_transformer

# get values
def getp():
  return pqs(abs(np.int16(mb_result.registers[0])))
  #return pqs(abs(mb_result.registers[0]))

def getq():
  return pqs(abs(np.int16(mb_result.registers[1])))

def gets():
  return pqs(abs(np.int16(mb_result.registers[2])))

def geturms():
  return (mb_result.registers[3] * 367.7) / 32767

def getirms():
  return (mb_result.registers[4] * 8.16 * current_transformer) / 32767

def getcosfi():
  return mb_result.registers[5] / 32767

def geterrorcode():
  return mb_result.registers[12]

# set Modbus ID
def setmodbusid(modbusid, newid):
  # ID: 1-255
  rc = 1
  if newid < 1:
    newid = 1
  if newid > 255:
    newid = 255
  try:
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(200, newid, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set baudrate
def setbaudrate(modbusid, newbaudrate):
  # 0: 9600 baud
  # 1: 4800 baud
  # 2: 2400 baud
  # 3: 1200 baud
  # 4:  600 baud
  rc = 1
  if newbaudrate < 0:
    newbaudrate = 0
  if newbaudrate > 4:
    newbaudrate = 4
  try:
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(201, newbaudrate, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set parity
def setparity(modbusid, newparity):
  # 0: odd
  # 1: even
  rc = 1
  if newparity < 0:
    newparity = 0
  if newparity > 1:
    newparity = 1
  try:
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(202, newparity, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc


