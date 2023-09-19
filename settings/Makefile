# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for system files                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="system files\t"
targetdir="/etc"
filemode=$(txtmode)

all:

clean:
	@$(rm) systemd/system/$(name).service

install:
	@echo -n "- Installing "$(title)"["
	@if [ -f "/etc/motd" ]; \
	then \
	  cp /etc/motd /etc/motd.`date +%s`; \
	fi
	@$(install) --mode $(filemode) modt $(targetdir)/
	@echo -n "#" 
	@$(install) --directory $(targetdir)/cron.d
	@$(install) --mode $(filemode) cron.d/$(name)* $(targetdir)/cron.d/
	@echo -n "###" 
	@$(install) --directory $(targetdir)/init.d
	@$(install) --mode $(filemode) init.d/$(name)* $(targetdir)/init.d/
	@echo -n "#" 
	@$(install) --directory $(targetdir)/init.d
	@$(install) --mode $(filemode) systemd/system/$(name)* $(targetdir)/systemd/system/
	@echo -n "#" 
	@echo "]"

uninstall:
	@echo -n "- Removing "$(title)"["
	@$(rm) $(targetdir)/cron.d/$(name)*
	@echo -n "###" 
	@$(rm) $(targetdir)/init.d/$(name)*
	@echo -n "#" 
	@$(rm) $(targetdir)/systemd/system/$(name).service
	@echo -n "#" 
	@echo "]"
