#
#   macosx-i686-debug.mk -- Build It Makefile to build SQLite Library for macosx on i686
#

PLATFORM       := macosx-i686-debug
CC             := cc
LD             := /usr/bin/ld
CFLAGS         := -fPIC -Wall -g
DFLAGS         := -DPIC -DBLD_FEATURE_SQLITE=1 -DCPU=I686
IFLAGS         := -I$(PLATFORM)/inc
LDFLAGS        := -Wl,-rpath,@executable_path/../lib -Wl,-rpath,@executable_path/ -Wl,-rpath,@loader_path/ -L$(PLATFORM)/lib -g -ldl
LIBS           := -lpthread -lm

all: prep \
        $(PLATFORM)/lib/libsqlite3.dylib

.PHONY: prep

prep:
	@[ ! -x $(PLATFORM)/inc ] && mkdir -p $(PLATFORM)/inc $(PLATFORM)/obj $(PLATFORM)/lib $(PLATFORM)/bin ; true
	@[ ! -f $(PLATFORM)/inc/buildConfig.h ] && cp projects/buildConfig.$(PLATFORM) $(PLATFORM)/inc/buildConfig.h ; true

clean:
	rm -rf $(PLATFORM)/lib/libsqlite3.dylib
	rm -rf $(PLATFORM)/obj/sqlite.o
	rm -rf $(PLATFORM)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(PLATFORM)

$(PLATFORM)/inc/sqlite3.h: 
	rm -fr macosx-i686-debug/inc/sqlite3.h
	cp -r src/sqlite3.h macosx-i686-debug/inc/sqlite3.h

$(PLATFORM)/obj/sqlite.o: \
        src/sqlite.c \
        $(PLATFORM)/inc/buildConfig.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite.o -arch i686 $(CFLAGS) $(DFLAGS) -I$(PLATFORM)/inc src/sqlite.c

$(PLATFORM)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(PLATFORM)/inc/buildConfig.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite3.o -arch i686 $(CFLAGS) $(DFLAGS) -I$(PLATFORM)/inc src/sqlite3.c

$(PLATFORM)/lib/libsqlite3.dylib:  \
        $(PLATFORM)/inc/sqlite3.h \
        $(PLATFORM)/obj/sqlite.o \
        $(PLATFORM)/obj/sqlite3.o
	$(CC) -dynamiclib -o $(PLATFORM)/lib/libsqlite3.dylib -arch i686 $(LDFLAGS) -install_name @rpath/libsqlite3.dylib $(PLATFORM)/obj/sqlite.o $(PLATFORM)/obj/sqlite3.o $(LIBS)

