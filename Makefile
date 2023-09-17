# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =	binary documents manuals messages programs scripts settings settings/mm8d \
        webpage/cgi-bin webpage/html webpage/pics webpage source

all:
	@echo "Compiling source code:"
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo "Cleaning source code:"
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@$(rm) Makefile.global
	@$(rm) config.log
	@$(rm) config.status
	@echo "Source code is cleaned."

install:
	@echo "Installing program to "$(prefix)":"
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Creating other directories:"
	@if [ $(prefix) == "/usr" ]; then n="local"; else n=""; fi;
	@install --directory $(printf "/var/$(n)/lib/$(name)/%01d " {0..8})
	@$(install) --directory /var/$(n)/lock/
	@$(install) --directory /var/$(n)/log/
	@echo "Setting system services:"
	@service $(name) stop
	@$(ln) /etc/init.d/$(name).sh /etc/rc0.d/K01$(name).sh
	@$(ln) /etc/init.d/$(name).sh /etc/rc2.d/S01$(name).sh
	@$(ln) /etc/init.d/$(name).sh /etc/rc3.d/S01$(name).sh
	@$(ln) /etc/init.d/$(name).sh /etc/rc4.d/S01$(name).sh
	@$(ln) /etc/init.d/$(name).sh /etc/rc5.d/S01$(name).sh
	@$(ln) /etc/init.d/$(name).sh /etc/rc6.d/K01$(name).sh
	@systemctl daemon-reload
	@systemctl enable $(name).service
	@service $(name) start
	@service cron restart
	@$(name)-updatestartpage
	@echo "Program is installed."

uninstall:
	@echo "Setting system services:"
	@service $(name) stop
	@systemctl disable $(name).service
	@echo "Removing program from "$(prefix)":"
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir uninstall; fi; \
	done
	@$(rm) /etc/rc0.d/K01$(name).sh
	@$(rm) /etc/rc2.d/S01$(name).sh
	@$(rm) /etc/rc3.d/S01$(name).sh
	@$(rm) /etc/rc4.d/S01$(name).sh
	@$(rm) /etc/rc5.d/S01$(name).sh
	@$(rm) /etc/rc6.d/K01$(name).sh
	@systemctl daemon-reload
	@service cron restart
	@echo "Removing other directories:"
	@if [ $(prefix) == "/usr" ]; then n="local"; else n=""; fi;
	@$(rmdir) $(printf "/var/$(n)/lib/$(name)/%01d " {0..8})
	@$(rmdir) /var/$(n)/lib/$(name)
	@echo "Program is removed."
