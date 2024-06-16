# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | pta9b01.py                                                                 |
# | Temperature meter handler module                                           |
# +----------------------------------------------------------------------------+
#
#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.2 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.
# 
# Exit codes:
#   0: error
#   1: normal exit

import serial
import time 
from pymodbus.client import ModbusSerialClient

global baudrate
global databits
global method
global parity
global port

# default
baudrate = 9600
bytesize = 8
method = 'rtu'
parity = 'N'
port = '/dev/ttyS0'

#read all register
def readregisters(modbusid):
  global mb_result
  rc = 1
  try:
    mb_reg = 0
    mb_regs = 2
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_result = mb_client.read_holding_registers(mb_reg, mb_regs, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# R/T: resistivity of the PT-100/temperature
def rt(raw):
  return raw / 10

# get values
def gett():
  return rt(mb_result.registers[0])

def getr():
  return rt(mb_result.registers[1])

# set Modbus ID
def setmodbusid(modbusid, newid):
  # ID: 1-247
  rc = 1
  if newid < 1:
    newid = 1
  if newid > 247:
    newid = 247
  try:
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(2, newid, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

# set baudrate
def setbaudrate(modbusid, newbaudrate):
  # 0:  1200 baud
  # 1:  2400 baud
  # 2:  4800 baud
  # 3:  9600 baud
  # 4: 19200 baud
  rc = 1
  if newbaudrate < 0:
    newbaudrate = 0
  if newbaudrate > 4:
    newbaudrate = 4
  try:
    mb_client = ModbusSerialClient(framer=method, bytesize=bytesize, parity=parity, method=method, port=port, baudrate=baudrate)
    mb_client.connect()
    mb_client.write_register(3, newbaudrate, modbusid)
    mb_client.close()
    time.sleep(0.001)
  except:
    rc = 0
  return rc

