#
#   sqlite-linux-static.mk -- Makefile to build SQLite Library for linux
#

PRODUCT         ?= sqlite
VERSION         ?= 1.0.0
BUILD_NUMBER    ?= 0
PROFILE         ?= static
ARCH            ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              ?= linux
CC              ?= /usr/bin/gcc
LD              ?= /usr/bin/ld
CONFIG          ?= $(OS)-$(ARCH)-$(PROFILE)

CFLAGS          += -fPIC -O2  -w
DFLAGS          += -D_REENTRANT -DBIT_FEATURE_SQLITE=1 -DPIC$(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc
LDFLAGS         += '-Wl,--enable-new-dtags' '-Wl,-rpath,$$ORIGIN/' '-Wl,-rpath,$$ORIGIN/../bin' '-rdynamic'
LIBPATHS        += -L$(CONFIG)/bin
LIBS            += -lpthread -lm -lrt -ldl

DEBUG           ?= release
CFLAGS-debug    := -g
CFLAGS-release  := -O2
DFLAGS-debug    := -DBIT_DEBUG
DFLAGS-release  := 
LDFLAGS-debug   := -g
LDFLAGS-release := 
CFLAGS          += $(CFLAGS-$(PROFILE))
DFLAGS          += $(DFLAGS-$(PROFILE))
LDFLAGS         += $(LDFLAGS-$(PROFILE))

all compile: prep \
        $(CONFIG)/bin/libsqlite3.a

.PHONY: prep

prep:
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-$(OS)-$(PROFILE)-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-$(OS)-$(PROFILE)-bit.h >/dev/null ; then\
		echo cp projects/sqlite-$(OS)-$(PROFILE)-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-$(OS)-$(PROFILE)-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true
	@echo $(DFLAGS) $(CFLAGS) >projects/.flags

clean:
	rm -rf $(CONFIG)/bin/libsqlite3.a
	rm -rf $(CONFIG)/obj/sqlite.o
	rm -rf $(CONFIG)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/sqlite3.h:  \
        $(CONFIG)/inc/bit.h
	rm -fr $(CONFIG)/inc/sqlite3.h
	cp -r src/sqlite3.h $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
        src/sqlite.c \
        $(CONFIG)/inc/bit.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fPIC -O2 $(DFLAGS) -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/bit.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fPIC -O2 $(DFLAGS) -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/bin/libsqlite3.a:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	/usr/bin/ar -cr $(CONFIG)/bin/libsqlite3.a $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o

version: 
	@echo 1.0.0-0 

