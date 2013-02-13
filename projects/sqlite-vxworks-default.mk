#
#   sqlite-vxworks-default.mk -- Makefile to build SQLite Library for vxworks
#

export WIND_BASE := $(WIND_BASE)
export WIND_HOME := $(WIND_BASE)/..
export WIND_PLATFORM := $(WIND_PLATFORM)

PRODUCT         := sqlite
VERSION         := 1.0.0
BUILD_NUMBER    := 0
PROFILE         := default
ARCH            := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              := vxworks
CC              := ccpentium
LD              := /usr/bin/ld
CONFIG          := $(OS)-$(ARCH)-$(PROFILE)
LBIN            := $(CONFIG)/bin

BIT_ROOT_PREFIX       := deploy
BIT_BASE_PREFIX       := $(BIT_ROOT_PREFIX)
BIT_DATA_PREFIX       := $(BIT_PRODUCTVER_PREFIX)
BIT_STATE_PREFIX      := $(BIT_PRODUCTVER_PREFIX)
BIT_BIN_PREFIX        := $(BIT_PRODUCTVER_PREFIX)
BIT_INC_PREFIX        := $(BIT_PRODUCTVER_PREFIX)/inc
BIT_LIB_PREFIX        := $(BIT_PRODUCTVER_PREFIX)
BIT_MAN_PREFIX        := $(BIT_PRODUCTVER_PREFIX)
BIT_SBIN_PREFIX       := $(BIT_PRODUCTVER_PREFIX)
BIT_ETC_PREFIX        := $(BIT_PRODUCTVER_PREFIX)
BIT_WEB_PREFIX        := $(BIT_PRODUCTVER_PREFIX)/web
BIT_LOG_PREFIX        := $(BIT_PRODUCTVER_PREFIX)
BIT_SPOOL_PREFIX      := $(BIT_PRODUCTVER_PREFIX)
BIT_CACHE_PREFIX      := $(BIT_PRODUCTVER_PREFIX)
BIT_APP_PREFIX        := $(BIT_BASE_PREFIX)
BIT_VAPP_PREFIX       := $(BIT_PRODUCT_PREFIX)
BIT_SRC_PREFIX        := $(BIT_ROOT_PREFIX)usr/src/$(PRODUCT)-$(VERSION)

CFLAGS          += -fno-builtin -fno-defer-pop -fvolatile -w
DFLAGS          += -D_REENTRANT -DVXWORKS -DRW_MULTI_THREAD -D_GNU_TOOL -DBIT_FEATURE_SQLITE=1 -DCPU=PENTIUM $(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc -I$(WIND_BASE)/target/h -I$(WIND_BASE)/target/h/wrn/coreip
LDFLAGS         += '-Wl,-r'
LIBPATHS        += -L$(CONFIG)/bin
LIBS            += 

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
        $(CONFIG)/bin/libsqlite3.out

.PHONY: prep

prep:
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(BIT_PRODUCT_PREFIX)" = "" ] ; then echo WARNING: BIT_PRODUCT_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-vxworks-default-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-vxworks-default-bit.h >/dev/null ; then\
		echo cp projects/sqlite-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true
clean:
	rm -rf $(CONFIG)/bin/libsqlite3.out
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
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fno-builtin -fno-defer-pop -fvolatile $(DFLAGS) $(IFLAGS) src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
    src/sqlite3.c\
    $(CONFIG)/inc/bit.h \
    $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fno-builtin -fno-defer-pop -fvolatile $(DFLAGS) $(IFLAGS) src/sqlite3.c

$(CONFIG)/bin/libsqlite3.out: \
    $(CONFIG)/inc/sqlite3.h \
    $(CONFIG)/obj/sqlite.o \
    $(CONFIG)/obj/sqlite3.o
	$(CC) -r -o $(CONFIG)/bin/libsqlite3.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o 

version: 
	@echo 1.0.0-0

