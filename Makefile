# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =	binary documents manuals messages programs scripts webpage/cgi-bin \
        webpage/html webpage/pics webpage source

all:
	@echo Compiling source code:
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo Cleaning source code:
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@$(rm) Makefile.global
	@$(rm) config.log
	@$(rm) config.status
	@echo "Source code is cleaned."

install:
	@echo Installing program to $(prefix):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Program is installed."

uninstall:
	@echo Removing program from $(prefix):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir uninstall; fi; \
	done
	@echo "Program is removed."
#	@echo Creating other directories:
#         /var/$INSTDIR/lib/$SWN2/0-8
#         /var/$INSTDIR/lock \
#         /var/$INSTDIR/log \
