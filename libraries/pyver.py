#!/usr/bin/python3

import sys

version = sys.version.split()[0]
print(version.split('.')[0] + '.' + version.split('.')[1])
sys.exit()

