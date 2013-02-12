#
#   sqlite-macosx-default.mk -- Makefile to build SQLite Library for macosx
#

PRODUCT         := sqlite
VERSION         := 1.0.0
BUILD_NUMBER    := 0
PROFILE         := default
ARCH            := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              := macosx
CC              := /usr/bin/clang
LD              := /usr/bin/ld
CONFIG          := $(OS)-$(ARCH)-$(PROFILE)
LBIN            := $(CONFIG)/bin

BIT_ROOT_PREFIX := /
BIT_BASE_PREFIX := $(BIT_ROOT_PREFIX)usr/lib
BIT_CFG_PREFIX  := $(BIT_ROOT_PREFIX)etc/$(PRODUCT)
BIT_PRD_PREFIX  := $(BIT_BASE_PREFIX)/$(PRODUCT)
BIT_VER_PREFIX  := $(BIT_PRD_PREFIX)/$(VERSION)
BIT_BIN_PREFIX  := $(BIT_VER_PREFIX)/bin
BIT_INC_PREFIX  := $(BIT_VER_PREFIX)/inc
BIT_LIB_PREFIX  := $(BIT_VER_PREFIX)/lib
BIT_LOG_PREFIX  := $(BIT_ROOT_PREFIX)var/log/$(PRODUCT)
BIT_SPL_PREFIX  := $(BIT_ROOT_PREFIX)var/spool/$(PRODUCT)
BIT_SRC_PREFIX  := $(BIT_ROOT_PREFIX)usr/src/$(PRODUCT)-$(VERSION)
BIT_WEB_PREFIX  := $(BIT_ROOT_PREFIX)var/www/$(PRODUCT)-default
BIT_MAN_PREFIX  := $(BIT_ROOT_PREFIX)usr/local/share/man
BIT_UBIN_PREFIX := $(BIT_ROOT_PREFIX)usr/local/bin

CFLAGS          += -w
DFLAGS          += -DBIT_FEATURE_SQLITE=1  $(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc
LDFLAGS         += '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/'
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
        $(CONFIG)/bin/libsqlite3.dylib

.PHONY: prep

prep:
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(BIT_PRD_PREFIX)" = "" ] ; then echo WARNING: BIT_PRD_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-macosx-default-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-macosx-default-bit.h >/dev/null ; then\
		echo cp projects/sqlite-macosx-default-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-macosx-default-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true
clean:
	rm -rf $(CONFIG)/bin/libsqlite3.dylib
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
	$(CC) -c -o $(CONFIG)/obj/sqlite.o $(DFLAGS) $(IFLAGS) src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
    src/sqlite3.c\
    $(CONFIG)/inc/bit.h \
    $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o $(DFLAGS) $(IFLAGS) src/sqlite3.c

$(CONFIG)/bin/libsqlite3.dylib: \
    $(CONFIG)/inc/sqlite3.h \
    $(CONFIG)/obj/sqlite.o \
    $(CONFIG)/obj/sqlite3.o
	$(CC) -dynamiclib -o $(CONFIG)/bin/libsqlite3.dylib $(LDFLAGS) -compatibility_version 1.0.0 -current_version 1.0.0 $(LIBPATHS) -install_name @rpath/libsqlite3.dylib $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

version: 
	@echo 1.0.0-0

