#
#   sqlite-linux.mk -- Build It Makefile to build SQLite Library for linux
#

ARCH     := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/')
OS       := linux
PROFILE  := debug
CONFIG   := $(OS)-$(ARCH)-$(PROFILE)
CC       := gcc
LD       := ld
CFLAGS   := -fPIC -g -mtune=generic -w
DFLAGS   := -D_REENTRANT -DBIT_FEATURE_SQLITE=1 -DPIC -DBIT_DEBUG
IFLAGS   := -I$(CONFIG)/inc
LDFLAGS  := '-Wl,--enable-new-dtags' '-Wl,-rpath,$$ORIGIN/' '-Wl,-rpath,$$ORIGIN/../bin' '-rdynamic' '-g'
LIBPATHS := -L$(CONFIG)/bin
LIBS     := -lpthread -lm -ldl

all: prep \
        $(CONFIG)/bin/libsqlite3.so

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-$(OS)-bit.h >/dev/null ; then\
		echo cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
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
        src/sqlite.c \
        $(CONFIG)/inc/bit.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fPIC -g -Wno-unused-result -mtune=generic $(DFLAGS) -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/bit.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fPIC -g -Wno-unused-result -mtune=generic $(DFLAGS) -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/bin/libsqlite3.so:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	$(CC) -shared -o $(CONFIG)/bin/libsqlite3.so $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

