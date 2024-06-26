> [!WARNING]
> This version (v0.6) is still under development, please use the previous one!

## MM8D * Growing house and irrigation controlling and remote monitoring system
Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>  
Homepage: <http://www.pozsarzs.hu>  
GitHub: <https://github.com/pozsarzs/mm8d-sw>  

#### Required hardware
 - Raspberry Pi or PC
 - [MM8D interface board](https://github.com/pozsarzs/mm8d-hw) (hardware documentation)

**Used external devices**
 - [MM6D Grow house control device](https://github.com/pozsarzs/mm6d-hw) (hardware documentation)
 - [MM6D Grow house control device](https://github.com/pozsarzs/mm6d-sw) (software)

 - [MM7D RH/T measuring device](https://github.com/pozsarzs/mm7d-hw) (hardware documentation)
 - [MM7D RH/T measuring device](https://github.com/pozsarzs/mm7d-sw) (software)

 - [MM9A Irrigation controller](https://github.com/pozsarzs/mm9a) (hardware documentation)

### Optional hardware
 - [Mini serial console](https://github.com/pozsarzs/mini_serial_console-hw) (hardware documentation - original)
 - [Mini serial console](https://github.com/pozsarzs/mini_serial_console_mm8d-sw) (software)

 - DM36B06 6 digit display with Modbus/RTU access via RS-485 serial connection
 - Datcon DT510 power meter with Modbus/ASCII access via RS-232 serial connection
 - PTA8B01 temperature meter  with Modbus/RTU access via RS-485 serial connection

#### Software
|features              |                                                |
|:---------------------|------------------------------------------------|
|architecture          |amd64, armhf, i386                              |
|operation system      |Raspberry Pi OS, Debian GNU/Linux               |
|version               |v0.6                                            |
|language              |en (hu)                                         |
|licence               |EUPL v1.2                                       |
|local user interface  |CLI, TUI, WUI                                   |
|remote access         |HTTP (html, txt, xml), SSH                      |
|remote device access  |RS-232/485: Modbus/ASCII, Modbus/RTU            |
|                      |LAN: HTTP, Modbus/TCP                           |
|                      |I/O: LPT port with interface cards              |
|                      |- 5 isolated inputs 24-36 V DC                  |
|                      |- 4 open collector LED outputs                  |
|                      |- 8 NO/NC relay contact outputs                 |
|                      |- 4 open collector relay state sign LED outputs |
 
#### External libraries in the package
 - [portio](http://portio.inrim.it/portio-0.5.tar.gz) library v0.5 by Fabrizio Pollastri (GNU GPL)
 - [PyModbus](https://github.com/pymodbus-dev/pymodbus/archive/refs/tags/v3.6.8.tar.gz) library v3.6.8 by Pymodbus (BSD)
 
