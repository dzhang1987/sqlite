#
#   linux-i686-debug.mk -- Build It Makefile to build SQLite Library for linux on i686
#

OS       := linux
CONFIG   := $(OS)-i686-debug
CC       := gcc
LD       := ld
CFLAGS   := -Wall -fPIC -g -Wno-unused-result -mtune=i686
DFLAGS   := -D_REENTRANT -DBLD_FEATURE_SQLITE=1 -DPIC -DBLD_DEBUG
IFLAGS   := -I$(CONFIG)/inc
LDFLAGS  := '-Wl,--enable-new-dtags' '-Wl,-rpath,$$ORIGIN/' '-Wl,-rpath,$$ORIGIN/../lib' '-rdynamic' '-g'
LIBPATHS := -L$(CONFIG)/lib
LIBS     := -lpthread -lm -ldl

all: prep \
        $(CONFIG)/lib/libsqlite3.so

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-$(OS)-bit.h >/dev/null ; then\
		echo cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/lib/libsqlite3.so
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
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fPIC -g -Wno-unused-result -mtune=i686 -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/bit.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fPIC -g -Wno-unused-result -mtune=i686 -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/lib/libsqlite3.so:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	$(CC) -shared -o $(CONFIG)/lib/libsqlite3.so $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)
