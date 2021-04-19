# +----------------------------------------------------------------------------+
# | MM8D v0.1 * Growing house controlling and remote monitoring device         |
# | Copyright (C) 2020-2021 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

srcfiles = override.pas
binfiles = mm8d-override.bin

all:
	@echo "- Compiling source code..."
	@mkdir -p ../_lib/$(architecture)-$(os)/
	@for x in $(srcfiles); do \
	  if [ -e $$x ]; then fpc $(fpflag) $$x; echo ""; fi; \
	done
	@mv ../_lib/$(architecture)-$(os)/override ../_lib/$(architecture)-$(os)/$(name)-override.bin
	@echo "...done."

clean:
	@echo -n "- Cleaning source code..."
	@$(rm) ../_lib/$(architecture)-$(os)/*
	@echo "...done."

install:
	@echo -n "- Installing binary files..."
	@for x in $(binfiles); do \
	  if [ -e ../_lib/$(architecture)-$(os)/$$x ]; then $(install) -m $(binmode) ../_lib/$(architecture)-$(os)/$$x ../../binary/$(architecture)/; fi; \
	done
	@echo "...done."
