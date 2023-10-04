# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for many files of the same type                                   |
# +----------------------------------------------------------------------------+

include ../../Makefile.global

title="picture files\t"
removetargetdir=1
sourcedir="."
targetdir="/var/www/html/pics"
filemode=$(txtmode)
files=`ls $(sourcedir) | grep -v Makefile`

all:

clean:

install:
	@echo -n "- Installing "$(title)"["
	@$(install) --directory $(targetdir)
	@$(install) --directory $(targetdir)/../snapshots
	@$(install) --directory $(targetdir)/../diagrams
	@chown root:www-data $(targetdir)/../snapshots
	@chown root:www-data $(targetdir)/../diagrams
	@chmod 777 $(targetdir)/../diagrams
	@chmod 777 $(targetdir)/../snapshots
	@chmod 775 $(targetdir)
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
	  if [ -d $(targetdir) ]; then $(rmdir) $(targetdir)/../snapshots; fi; \
	  if [ -d $(targetdir) ]; then $(rmdir) $(targetdir)/../diagrams; fi; \
	fi
	@echo "]"
