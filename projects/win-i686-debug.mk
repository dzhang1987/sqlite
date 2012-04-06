#
#   win-i686-debug.mk -- Build It Makefile to build SQLite Library for win on i686
#

VS             := $(VSINSTALLDIR)
VS             ?= $(VS)
SDK            := $(WindowsSDKDir)
SDK            ?= $(SDK)

export         SDK VS
export PATH    := $(SDK)/Bin:$(VS)/VC/Bin:$(VS)/Common7/IDE:$(VS)/Common7/Tools:$(VS)/SDK/v3.5/bin:$(VS)/VC/VCPackages;$(PATH)
export INCLUDE := $(INCLUDE);$(SDK)/INCLUDE:$(VS)/VC/INCLUDE
export LIB     := $(LIB);$(SDK)/lib:$(VS)/VC/lib

CONFIG   := win-i686-debug
CC       := cl.exe
LD       := link.exe
CFLAGS   := -nologo -GR- -W3 -Zi -Od -MDd -Zi -Od -MDd
DFLAGS   := -D_REENTRANT -D_MT -DBLD_FEATURE_SQLITE=1
IFLAGS   := -I$(CONFIG)/inc -I$(CONFIG)/inc
LDFLAGS  := '-nologo' '-nodefaultlib' '-incremental:no' '-machine:x86' '-machine:x86'
LIBPATHS := -libpath:$(CONFIG)/bin -libpath:$(CONFIG)/bin
LIBS     := ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib shell32.lib

all: prep \
        $(CONFIG)/bin/libsqlite3.dll

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/buildConfig.h ] && cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h ; true
	@if ! diff $(CONFIG)/inc/buildConfig.h projects/buildConfig.$(CONFIG) >/dev/null ; then\
		echo cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
		cp projects/buildConfig.$(CONFIG) $(CONFIG)/inc/buildConfig.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/bin/libsqlite3.dll
	rm -rf $(CONFIG)/obj/sqlite.obj
	rm -rf $(CONFIG)/obj/sqlite3.obj

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/sqlite3.h: 
	rm -fr win-i686-debug/inc/sqlite3.h
	cp -r src/sqlite3.h win-i686-debug/inc/sqlite3.h

$(CONFIG)/obj/sqlite.obj: \
        src/sqlite.c \
        $(CONFIG)/inc/buildConfig.h
	"$(CC)" -c -Fo$(CONFIG)/obj/sqlite.obj -Fd$(CONFIG)/obj $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite.c

$(CONFIG)/obj/sqlite3.obj: \
        src/sqlite3.c \
        $(CONFIG)/inc/buildConfig.h
	"$(CC)" -c -Fo$(CONFIG)/obj/sqlite3.obj -Fd$(CONFIG)/obj $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc -I$(CONFIG)/inc src/sqlite3.c

$(CONFIG)/bin/libsqlite3.dll:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite.obj \
        $(CONFIG)/obj/sqlite3.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libsqlite3.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libsqlite3.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.obj $(CONFIG)/obj/sqlite3.obj $(LIBS)

