# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for message files                                                 |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="message files\t"
removetargetdir=0
sourcedir="."
targetdir=$(localedir)
filemode=$(txtmode)
languages = hu

all:

clean:

install:
	@echo -n "- Installing "$(title)"["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.msg ]; \
	  then \
	    $(install) --directory $(targetdir)/$$x; \
	    $(install) --mode $(filemode) $(sourcedir)/$(name)_$$x.msg $(targetdir)/$$x; \
	    mv $(targetdir)/$$x/$(name)_$$x.msg $(targetdir)/$$x/$(name).msg; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing "$(title)"["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.msg ]; \
	  then \
	    $(rm) $(targetdir)/$$x/$(name).msg; \
	    echo -n "#"; \
	  fi; \
	  if [ $(removetargetdir) -eq 1 ]; \
	  then \
	    if [ -d $(targetdir)/$$x ]; then $(rmdir) $(targetdir)/$$x; fi; \
	  fi; \
	done
	@echo "]"
