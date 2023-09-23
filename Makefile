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
	@echo "Compiling source code..."
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Done."

clean:
	@echo "Cleaning source code..."
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@$(rm) config.log
	@$(rm) config.status
	@$(rm) Makefile.global
	@echo "Done."

install:
	@echo "Installing program to "$(prefix)":"
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Creating other directories..."
	@for n in 0 1 2 3 4 5 6 7 8; do \
	  $(install) --directory $(vardir)/lib/$(name)/$$n; \
	done
	@$(install) --directory $(vardir)/lock/
	@$(install) --directory $(vardir)/log/
	@echo "Setting system services..."
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
	@echo "Done."

uninstall:
	@echo "Setting system services..."
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
	@echo "Removing other directories..."
	@for n in 0 1 2 3 4 5 6 7 8; do \
	  $(rmdir) $(vardir)/lib/$(name)/$$n; \
	done
	@$(rmdir) $(vardir)/lib/$(name)
	@$(rmdir) $(vardir)/log/
	@$(rmdir) $(vardir)/lock/
	@echo "Done."
