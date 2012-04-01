#
#   macosx-x86_64-debug.mk -- Build It Makefile to build SQLite Library for macosx on x86_64
#

PLATFORM       := macosx-x86_64-debug
CC             := /usr/bin/cc
LD             := /usr/bin/ld
CFLAGS         := -fPIC -Wall -g -Wshorten-64-to-32
DFLAGS         := -DPIC -DBLD_FEATURE_SQLITE=1 -DCPU=X86_64
IFLAGS         := -I$(PLATFORM)/inc
LDFLAGS        := '-Wl,-rpath,@executable_path/../lib' '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/' '-g' '-ldl'
LIBPATHS       := -L$(PLATFORM)/lib
LIBS           := -lpthread -lm

all: prep \
        $(PLATFORM)/lib/libsqlite3.dylib

.PHONY: prep

prep:
	@[ ! -x $(PLATFORM)/inc ] && mkdir -p $(PLATFORM)/inc $(PLATFORM)/obj $(PLATFORM)/lib $(PLATFORM)/bin ; true
	@[ ! -f $(PLATFORM)/inc/buildConfig.h ] && cp projects/buildConfig.$(PLATFORM) $(PLATFORM)/inc/buildConfig.h ; true
	@if ! diff $(PLATFORM)/inc/buildConfig.h projects/buildConfig.$(PLATFORM) >/dev/null ; then\
		echo cp projects/buildConfig.$(PLATFORM) $(PLATFORM)/inc/buildConfig.h  ; \
		cp projects/buildConfig.$(PLATFORM) $(PLATFORM)/inc/buildConfig.h  ; \
	fi; true

clean:
	rm -rf $(PLATFORM)/lib/libsqlite3.dylib
	rm -rf $(PLATFORM)/obj/sqlite.o
	rm -rf $(PLATFORM)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(PLATFORM)

$(PLATFORM)/inc/sqlite3.h: 
	rm -fr macosx-x86_64-debug/inc/sqlite3.h
	cp -r src/sqlite3.h macosx-x86_64-debug/inc/sqlite3.h

$(PLATFORM)/obj/sqlite.o: \
        src/sqlite.c \
        $(PLATFORM)/inc/buildConfig.h \
        $(PLATFORM)/inc/sqlite3.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite.o -arch x86_64 -fPIC -g $(DFLAGS) -I$(PLATFORM)/inc src/sqlite.c

$(PLATFORM)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(PLATFORM)/inc/buildConfig.h \
        $(PLATFORM)/inc/sqlite3.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite3.o -arch x86_64 -fPIC -g $(DFLAGS) -I$(PLATFORM)/inc src/sqlite3.c

$(PLATFORM)/lib/libsqlite3.dylib:  \
        $(PLATFORM)/inc/sqlite3.h \
        $(PLATFORM)/obj/sqlite.o \
        $(PLATFORM)/obj/sqlite3.o
	$(CC) -dynamiclib -o $(PLATFORM)/lib/libsqlite3.dylib -arch x86_64 $(LDFLAGS) $(LIBPATHS) -install_name @rpath/libsqlite3.dylib $(PLATFORM)/obj/sqlite.o $(PLATFORM)/obj/sqlite3.o $(LIBS)

