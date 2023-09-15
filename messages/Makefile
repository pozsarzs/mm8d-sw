# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for message files                                                 |
# +----------------------------------------------------------------------------+

include ../Makefile.global

languages = hu
target=$(localedir)
mode=$(txtmode)
title="message files"

all:

clean:

install:
	@echo -n "- Installing $(title) ["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.msg ]; \
	  then \
	    $(install) --directory $(target)/$$x; \
	    $(install) --mode $(mode) $(name)_$$x.msg $(target)/$$x; \
	    mv $(target)/$$x/$(name)_$$x.msg $(target)/$$x/$(name).msg; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"

uninstall:
	@echo -n "- Removing $(title) ["
	@for x in $(languages); do \
	  if [ -f $(name)_$$x.msg ]; \
	  then \
	    $(rm) $(localedir)/$$x/$(name).msg; \
	    echo -n "#"; \
	  fi; \
	done
	@echo "]"
