# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

dirs=editenvirconf editirrconf editmainconf override

all:
	@mkdir --parents _lib/$(architecture)-$(os)/
	@for x in $(dirs); do \
	  if [ -d $$x ]; \
	  then \
	    cd $$x; \
	    fpc $(fpflag) $$x; \
	    cd ..; \
	    echo ""; \
	  fi; \
	  mv _lib/$(architecture)-$(os)/$$x ../binary/$(architecture)/$(name)-$$x.bin; \
	done

clean:
	@for x in $(dirs); do \
	  $(rm) $$x/config.pas; \
	done
	@$(rm) _lib/$(architecture)-$(os)/*

install:

uninstall:
