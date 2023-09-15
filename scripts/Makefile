# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for  many files of the same type                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

files= `ls | grep -v Makefile | grep -v ??`
target=$(bindir)
mode=$(binmode)
title="shell scripts"

all:

clean:

install:
	@echo -n "- Installing $(title) ["
	@$(install) --directory $(target)
	@for x in $(files); do \
	  if [ -f $$x ]; \
	  then \
	    $(install) --mode $(mode) $$x $(target); \
	    echo -n "#"; \
	  fi \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing $(title) ["
	@for x in $(files); do \
	  $(rm) $(target)/$$x; \
	  echo -n "#"; \
	done
	@echo "]"
