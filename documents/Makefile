# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for many files of the same type                                   |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="documentation"
removetargetdir=1
sourcedir="."
targetdir=$(datarootdir)/doc/$(name)
filemode=$(txtmode)
files=`ls $(sourcedir) | grep -v Makefile`

all:

clean:

install:
	@echo -n "- Installing $(title) ["
	@$(install) --directory $(targetdir)
	@for x in $(files); do \
	  if [ -f $(sourcedir)/$$x ]; \
	  then \
	    $(install) --mode $(filemode) $(sourcedir)/$$x $(targetdir); \
	    echo -n "#"; \
	  fi \
	done
	@$(install) --mode $(filemode) "../LICENCE" $(targetdir)	
	@echo -n "#"
	@echo "]"

uninstall:
	@echo -n "- Removing $(title) ["
	@$(rm) $(targetdir)/LICENCE
	@echo -n "#"
	@for x in $(files); do \
	  $(rm) $(targetdir)/$$x; \
	  echo -n "#"; \
	done
	@if [ $(removetargetdir) -eq 1 ]; \
	then \
	  $(rmdir) $(targetdir)/$$x ; \
	fi;
	@echo "]"
