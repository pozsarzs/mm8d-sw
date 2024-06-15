# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for many files of the same type                                   |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="binary files \t"
removetargetdir=0
sourcedir=$(architecture)
targetdir=$(bindir)
filemode=$(binmode)
files=`ls $(sourcedir) | grep -v Makefile`

all:

clean:

install:
	@echo -n "- Installing "$(title)"["
	@$(install) --directory $(targetdir)
	@for x in $(files); do \
	  if [ -f $(sourcedir)/$$x ]; \
	  then \
	    $(install) --mode $(filemode) $(sourcedir)/$$x $(targetdir); \
	    echo -n "#"; \
	  fi \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing "$(title)"["
	@for x in $(files); do \
	  $(rm) $(targetdir)/$$x; \
	  echo -n "#"; \
	done
	@if [ $(removetargetdir) -eq 1 ]; \
	then \
	  if [ -d $(targetdir) ]; then $(rmdir) $(targetdir); fi; \
	fi
	@echo "]"
