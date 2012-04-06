#
#   linux-i686-debug.mk -- Build It Makefile to build SQLite Library for linux on i686
#

CONFIG   := linux-i686-debug
CC       := cc
LD       := ld
CFLAGS   := -Wall -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686
DFLAGS   := -D_REENTRANT -DCPU=${ARCH} -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC
IFLAGS   := -I$(CONFIG)/inc -I$(CONFIG)/inc
LDFLAGS  := '-Wl,--enable-new-dtags' '-Wl,-rpath,$$ORIGIN/' '-Wl,-rpath,$$ORIGIN/../lib'
LIBPATHS := -L$(CONFIG)/lib -L$(CONFIG)/lib
LIBS     := -lpthread -lm -ldl -lpthread -lm -ldl

all: prep \
        $(CONFIG)/lib/libsqlite3.so

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/buildConfig.h ] && cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h ; true
	@if ! diff $(CONFIG)/inc/buildConfig.h projects/buildConfig.$(CONFIG) >/dev/null ; then\
		echo cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
		cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/lib/libsqlite3.so
	rm -rf $(CONFIG)/obj/sqlite.o
	rm -rf $(CONFIG)/obj/sqlite3.o

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/sqlite3.h: 
	rm -fr linux-i686-debug/inc/sqlite3.h
	cp -r src/sqlite3.h linux-i686-debug/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
        src/sqlite.c \
        $(CONFIG)/inc/buildConfig.h
	$(CC) -c -o $(CONFIG)/obj/sqlite.o -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.o: \
        src/sqlite3.c \
        $(CONFIG)/inc/buildConfig.h
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/lib/libsqlite3.so:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.o \
        $(CONFIG)/obj/sqlite3.o
	$(CC) -shared -o $(CONFIG)/lib/libsqlite3.so $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(CONFIG)/obj/sqlite3.o $(LIBS)

