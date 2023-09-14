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

all:

clean:

install:
	@echo -n "- Installing manual files..."
	@$(install) -d $(mandir)/man1;
	@for x in $(man1files); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(mandir)/man1/; fi; \
	done
	@$(install) -d $(mandir)/man7;
	@for x in $(man7files); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(mandir)/man7/; fi; \
	done
	@$(install) -d $(mandir)/man8;
	@for x in $(man8files); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(mandir)/man8/; fi; \
	done
	@echo "done."

uninstall:
	@echo -n "- Removing manual files..."
	@for x in $(man1files); do \
	  if [ -e $$x ]; then $(rm) $(mandir)/man1/$$x; fi; \
	done
	@for x in $(man7files); do \
	  if [ -e $$x ]; then $(rm) $(mandir)/man7/$$x; fi; \
	done
	@for x in $(man8files); do \
	  if [ -e $$x ]; then $(rm) $(mandir)/man8/$$x; fi; \
	done
	@echo "done."
