# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for documents                                                     |
# +----------------------------------------------------------------------------+

include ../Makefile.global

docfiles= `ls | grep -v Makefile | grep -v ??`

all:

clean:

install:
	@echo -n "- Installing document files..."
	@$(install) -d $(datarootdir)/doc/$(name)/
	@for x in $(docfiles); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(datarootdir)/doc/$(name)/; fi; \
	done
	@$(install) -m $(txtmode) "../LICENCE" $(datarootdir)/doc/$(name)/	
	@echo "done."

uninstall:
	@echo -n "- Removing document files..."
	@$(rm) $(datarootdir)/doc/$(name)/LICENCE
	@for x in $(docfiles); do \
	  if [ -e $$x ]; then $(rm) $(datarootdir)/doc/$(name)/$$x; fi; \
	done
	@rmdir $(datarootdir)/doc/$(name)/
	@echo "done."
