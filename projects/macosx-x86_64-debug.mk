#
#   macosx-x86_64-debug.mk -- Build It Makefile to build SQLite Library for macosx on x86_64
#

CONFIG   := macosx-x86_64-debug
CC       := /usr/bin/cc
LD       := /usr/bin/ld
CFLAGS   := -fPIC -Wall -fast -Wshorten-64-to-32
DFLAGS   := -DPIC -DBLD_FEATURE_SQLITE=1 -DCPU=X86_64
IFLAGS   := -I$(CONFIG)/inc -I$(CONFIG)/inc
LDFLAGS  := '-Wl,-rpath,@executable_path/../lib' '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/'
LIBPATHS := -L$(CONFIG)/lib
LIBS     := -lpthread -lm -ldl

all: prep \
        $(CONFIG)/lib/libsqlite3.dylib

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/buildConfig.h ] && cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h ; true
	@if ! diff $(CONFIG)/inc/buildConfig.h projects/buildConfig.$(CONFIG) >/dev/null ; then\
		echo cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
		cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/lib/libsqlite3.dylib
	rm -rf $(CONFIG)/obj/sqlite.o
	rm -rf $(CONFIG)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/sqlite3.h: 
	rm -fr macosx-x86_64-debug/inc/sqlite3.h
	cp -r src/sqlite3.h macosx-x86_64-debug/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
        src/sqlite.c \
        $(CONFIG)/inc/buildConfig.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -arch x86_64 -fPIC -fast $(DFLAGS) -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/buildConfig.h \
        $(CONFIG)/inc/sqlite3.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -arch x86_64 -fPIC -fast $(DFLAGS) -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/lib/libsqlite3.dylib:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	$(CC) -dynamiclib -o $(CONFIG)/lib/libsqlite3.dylib -arch x86_64 $(LDFLAGS) $(LIBPATHS) -install_name @rpath/libsqlite3.dylib $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

