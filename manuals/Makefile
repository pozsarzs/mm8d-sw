# +----------------------------------------------------------------------------+
# | MM8D v0.6 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2024 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for manuals                                                       |
# +----------------------------------------------------------------------------+

include ../Makefile.global

title="manuals\t\t"
removetargetdir=1
sourcedir="."
targetdir=$(mandir)
filemode=$(txtmode)
man1files= `ls *.1 | grep -v Makefile | grep -v '\.in'`
man7files= `ls *.7 | grep -v Makefile | grep -v '\.in'`
man8files= `ls *.8 | grep -v Makefile | grep -v '\.in'`

all:

clean:
	@for x in $(man1files); do \
	  if [ -f $(sourcedir)/$$x ]; \
	  then \
	    $(rm) $(sourcedir)/$$x; \
	  fi \
	done
	@for x in $(man7files); do \
	  if [ -f $(sourcedir)/$$x ]; \
	  then \
	    $(rm) $(sourcedir)/$$x; \
	  fi \
	done
	@for x in $(man8files); do \
	  if [ -f $(sourcedir)/$$x ]; \
	  then \
	    $(rm) $(sourcedir)/$$x; \
	  fi \
	done

install:
	@echo -n "- Installing "$(title)"["
	@$(install) --directory $(targetdir)/man1;
	@for x in $(man1files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(filemode) $(sourcedir)/$$x $(targetdir)/man1/; \
	    echo -n "#"; \
	    fi; \
	done
	@$(install) --directory $(targetdir)/man7;
	@for x in $(man7files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(filemode) $(sourcedir)/$$x $(targetdir)/man7/; \
	    echo -n "#"; \
	  fi; \
	done
	@$(install) --directory $(targetdir)/man8;
	@for x in $(man8files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(filemode) $(sourcedir)/$$x $(targetdir)/man8/; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing "$(title)"["
	@for x in $(man1files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(targetdir)/man1/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@for x in $(man7files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(targetdir)/man7/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@for x in $(man8files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(targetdir)/man8/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@if [ $(removetargetdir) -eq 1 ]; \
	then \
	  if [ -d $(targetdir)/man1 ]; then $(rmdir) $(targetdir)/man1; fi; \
	  if [ -d $(targetdir)/man7 ]; then $(rmdir) $(targetdir)/man7; fi; \
	  if [ -d $(targetdir)/man8 ]; then $(rmdir) $(targetdir)/man8; fi; \
	fi;
	@echo "]"
