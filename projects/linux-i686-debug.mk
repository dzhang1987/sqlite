#
#   linux-i686-debug.mk -- Build It Makefile to build SQLite Library for linux on i686
#

PLATFORM       := linux-i686-debug
CC             := cc
LD             := /usr/bin/ld
CFLAGS         := -Wall -fPIC -g -Wno-unused-result -mtune=i686
DFLAGS         := -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC
IFLAGS         := -I$(PLATFORM)/inc
LDFLAGS        := -Wl,--enable-new-dtags '-Wl,-rpath,$$ORIGIN/' '-Wl,-rpath,$$ORIGIN/../lib' -L$(PLATFORM)/lib -g -ldl
LIBS           := -lpthread -lm

all: prep \
        $(PLATFORM)/lib/libsqlite3.so

.PHONY: prep

prep:
	@[ ! -x $(PLATFORM)/inc ] && mkdir -p $(PLATFORM)/inc $(PLATFORM)/obj $(PLATFORM)/lib $(PLATFORM)/bin ; true
	@[ ! -f $(PLATFORM)/inc/buildConfig.h ] && cp projects/buildConfig.$(PLATFORM) $(PLATFORM)/inc/buildConfig.h ; true

clean:
	rm -rf $(PLATFORM)/lib/libsqlite3.so
	rm -rf $(PLATFORM)/obj/sqlite.o
	rm -rf $(PLATFORM)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(PLATFORM)

$(PLATFORM)/inc/sqlite3.h: 
	rm -fr linux-i686-debug/inc/sqlite3.h
	cp -r src/sqlite3.h linux-i686-debug/inc/sqlite3.h

$(PLATFORM)/obj/sqlite.o: \
        src/sqlite.c \
        $(PLATFORM)/inc/buildConfig.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite.o $(CFLAGS) $(DFLAGS) -I$(PLATFORM)/inc src/sqlite.c

$(PLATFORM)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(PLATFORM)/inc/buildConfig.h
	$(CC) -c -o $(PLATFORM)/obj/sqlite3.o $(CFLAGS) $(DFLAGS) -I$(PLATFORM)/inc src/sqlite3.c

$(PLATFORM)/lib/libsqlite3.so:  \
        $(PLATFORM)/inc/sqlite3.h \
        $(PLATFORM)/obj/sqlite.o \
        $(PLATFORM)/obj/sqlite3.o
	$(CC) -shared -o $(PLATFORM)/lib/libsqlite3.so $(LDFLAGS) $(PLATFORM)/obj/sqlite.o $(PLATFORM)/obj/sqlite3.o $(LIBS)

