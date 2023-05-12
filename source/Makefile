# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =  editenvirconf editirrconf editmainconf override

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
	@echo Installing binaries:
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Programs are installed."
