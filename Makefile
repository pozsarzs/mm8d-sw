# +----------------------------------------------------------------------------+
# | MM8D v0.5 * Growing house and irrigation controlling and monitoring system |
# | Copyright (C) 2020-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =	binary documents manuals messages programs scripts webpage/cgi-bin \
        webpage/pics webpage
srcdirs = source

all:
	@echo Compiling $(name):
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo Cleaning source code:
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@echo "Source code is cleaned."

install:

         /var/$INSTDIR/lib/$SWN2 \
         /var/$INSTDIR/lib/$SWN2/0 \
         /var/$INSTDIR/lib/$SWN2/1 \
         /var/$INSTDIR/lib/$SWN2/2 \
         /var/$INSTDIR/lib/$SWN2/3 \
         /var/$INSTDIR/lib/$SWN2/4 \
         /var/$INSTDIR/lib/$SWN2/5 \
         /var/$INSTDIR/lib/$SWN2/6 \
         /var/$INSTDIR/lib/$SWN2/7 \
         /var/$INSTDIR/lib/$SWN2/8 \
         /var/$INSTDIR/lock \
         /var/$INSTDIR/log \



	@echo Installing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo Creating other directories:


	@echo "Program is installed."

uninstall:
	@echo Removing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir uninstall; fi; \
	done
	@echo "Program is removed."
