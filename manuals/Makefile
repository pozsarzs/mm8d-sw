# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for manuals                                                       |
# +----------------------------------------------------------------------------+

include ../Makefile.global

man1files= `ls | grep -v Makefile | grep -v ?? | grep '.1.gz'`
man7files= `ls | grep -v Makefile | grep -v ?? | grep '.7.gz'`
man8files= `ls | grep -v Makefile | grep -v ?? | grep '.8.gz'`
target=$(mandir)
mode=$(txtmode)
title="manuals"

all:

clean:

install:
	@echo -n "- Installing $(title) ["
	@$(install) --directory $(target)/man1;
	@for x in $(man1files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(mode) $$x $(target)/man1/; \
	    echo -n "#"; \
	    fi; \
	done
	@$(install) --directory $(target)/man7;
	@for x in $(man7files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(mode) $$x $(target)/man7/; \
	    echo -n "#"; \
	  fi; \
	done
	@$(install) --directory $(target)/man8;
	@for x in $(man8files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(mode) $$x $(target)/man8/; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing $(title) ["
	@for x in $(man1files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(target)/man1/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@for x in $(man7files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(target)/man7/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@for x in $(man8files); do \
	  if [ -f $$x ]; \
	  then \
	    $(rm) $(target)/man8/$$x; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"
