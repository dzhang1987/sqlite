#
#   macosx-x86_64-debug.mk -- Build It Makefile to build SQLite Library for macosx on x86_64
#

ARCH     := x86_64
OS       := macosx
CONFIG   := $(OS)-$(ARCH)-debug
CC       := /usr/bin/clang
LD       := /usr/bin/ld
CFLAGS   := -Wall -g -Wno-unused-result -Wshorten-64-to-32
DFLAGS   := -DBLD_FEATURE_SQLITE=1 -DBLD_DEBUG
IFLAGS   := -I$(CONFIG)/inc
LDFLAGS  := '-Wl,-rpath,@executable_path/../lib' '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/' '-g'
LIBPATHS := -L$(CONFIG)/bin
LIBS     := -lpthread -lm -ldl

all: prep \
        $(CONFIG)/bin/libsqlite3.dylib

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/sqlite-$(OS)-bit.h >/dev/null ; then\
		echo cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/sqlite-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
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
        src/sqlite.c \
        $(CONFIG)/inc/bit.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -arch x86_64 -g -Wno-unused-result $(DFLAGS) -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/bit.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -arch x86_64 -g -Wno-unused-result $(DFLAGS) -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/bin/libsqlite3.dylib:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	$(CC) -dynamiclib -o $(CONFIG)/bin/libsqlite3.dylib -arch x86_64 $(LDFLAGS) -compatibility_version 1.0.0 -current_version 1.0.0 -compatibility_version 1.0.0 -current_version 1.0.0 $(LIBPATHS) -install_name @rpath/libsqlite3.dylib $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

