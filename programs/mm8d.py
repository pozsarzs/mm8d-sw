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
  import portio
else:
  import Adafruit_DHT
  import RPi.GPIO as GPIO


exit(0)
