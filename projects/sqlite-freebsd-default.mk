#
#   sqlite-freebsd-default.mk -- Makefile to build SQLite Library for freebsd
#

PRODUCT         := sqlite
VERSION         := 1.0.0
BUILD_NUMBER    := 0
PROFILE         := default
ARCH            := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              := freebsd
CC              := /usr/bin/gcc
LD              := /usr/bin/ld
CONFIG          := $(OS)-$(ARCH)-$(PROFILE)
LBIN            := $(CONFIG)/bin

BIT_ROOT_PREFIX := /
BIT_CFG_PREFIX  := $(BIT_ROOT_PREFIX)etc/sqlite
BIT_PRD_PREFIX  := $(BIT_ROOT_PREFIX)usr/lib/sqlite
BIT_VER_PREFIX  := $(BIT_ROOT_PREFIX)usr/lib/sqlite/1.0.0
BIT_BIN_PREFIX  := $(BIT_VER_PREFIX)/bin
BIT_INC_PREFIX  := $(BIT_VER_PREFIX)/inc
BIT_LOG_PREFIX  := $(BIT_ROOT_PREFIX)var/log/sqlite
BIT_SPL_PREFIX  := $(BIT_ROOT_PREFIX)var/spool/sqlite
BIT_SRC_PREFIX  := $(BIT_ROOT_PREFIX)usr/src/sqlite-1.0.0
BIT_WEB_PREFIX  := $(BIT_ROOT_PREFIX)var/www/sqlite-default
BIT_UBIN_PREFIX := $(BIT_ROOT_PREFIX)usr/local/bin
BIT_MAN_PREFIX  := $(BIT_ROOT_PREFIX)usr/local/share/man/man1

CFLAGS          += -fPIC  -w
DFLAGS          += -D_REENTRANT -DBIT_FEATURE_SQLITE=1 -DPIC  $(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc
LDFLAGS         += '-g'
LIBPATHS        += -L$(CONFIG)/bin
LIBS            += -lpthread -lm -ldl

DEBUG           := debug
CFLAGS-debug    := -g
DFLAGS-debug    := -DBIT_DEBUG
LDFLAGS-debug   := -g
DFLAGS-release  := 
CFLAGS-release  := -O2
LDFLAGS-release := 
CFLAGS          += $(CFLAGS-$(DEBUG))
DFLAGS          += $(DFLAGS-$(DEBUG))
LDFLAGS         += $(LDFLAGS-$(DEBUG))

unexport CDPATH

all compile: prep \
        $(CONFIG)/bin/libsqlite3.so

.PHONY: prep

prep:
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(BIT_PRD_PREFIX)" = "" ] ; then echo WARNING: BIT_PRD_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-freebsd-default-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-freebsd-default-bit.h >/dev/null ; then\
		echo cp projects/sqlite-freebsd-default-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-freebsd-default-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true
clean:
	rm -rf $(CONFIG)/bin/libsqlite3.so
	rm -rf $(CONFIG)/obj/sqlite.o
	rm -rf $(CONFIG)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/sqlite3.h: 
	rm -fr $(CONFIG)/inc/sqlite3.h
	cp -r src/sqlite3.h $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
    src/sqlite.c\
    $(CONFIG)/inc/bit.h \
    $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fPIC $(LDFLAGS) $(DFLAGS) $(IFLAGS) src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
    src/sqlite3.c\
    $(CONFIG)/inc/bit.h \
    $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fPIC $(LDFLAGS) $(DFLAGS) $(IFLAGS) src/sqlite3.c

$(CONFIG)/bin/libsqlite3.so: \
    $(CONFIG)/inc/sqlite3.h \
    $(CONFIG)/obj/sqlite.o \
    $(CONFIG)/obj/sqlite3.o
	$(CC) -shared -o $(CONFIG)/bin/libsqlite3.so $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

version: 
	@echo 1.0.0-0

