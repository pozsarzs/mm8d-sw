# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for scripts                                                       |
# +----------------------------------------------------------------------------+

include ../Makefile.global

scriptfiles= `ls | grep -v Makefile | grep -v ??`

all:

clean:


install:
	@$(install) --directory $(bindir)
	@for x in $(scriptfiles); do \
	  if [ -f $$x ]; then $(install) --mode $(binmode) $$x $(bindir); fi; \
	done
	@echo "Done."

uninstall:
	@for x in $(scriptfiles); do $(rm) $(bindir)/$$x; done
	@echo "Done."
