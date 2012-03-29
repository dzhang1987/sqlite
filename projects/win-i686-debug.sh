#
#   win-i686-debug.sh -- Build It Shell Script to build SQLite Library
#

export VS="$(PROGRAMFILES)\Microsoft Visual Studio 10.0"
export SDK="$(PROGRAMFILES)\Microsoft SDKs\Windows\v7.0A"
export PATH="$(SDK)/Bin:$(VS)/VC/Bin:$(VS)/Common7/IDE:$(VS)/Common7/Tools:$(VS)/SDK/v3.5/bin:$(VS)/VC/VCPackages;$(PATH)"
export INCLUDE="$(INCLUDE);$(SDK)/INCLUDE:$(VS)/VC/INCLUDE"
export LIB="$(LIB);$(SDK)/lib:$(VS)/VC/lib"

PLATFORM="win-i686-debug"
CC="cl.exe"
LD="link.exe"
CFLAGS="-nologo -GR- -W3 -Zi -Od -MDd"
DFLAGS="-D_REENTRANT -D_MT -DBLD_FEATURE_SQLITE=1"
IFLAGS="-Iwin-i686-debug/inc"
LDFLAGS="-nologo -nodefaultlib -incremental:no -debug -machine:x86"
LIBPATHS="-libpath:${PLATFORM}/bin"
LIBS="ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib shell32.lib"

[ ! -x ${PLATFORM}/inc ] && mkdir -p ${PLATFORM}/inc ${PLATFORM}/obj ${PLATFORM}/lib ${PLATFORM}/bin
[ ! -f ${PLATFORM}/inc/buildConfig.h ] && cp projects/buildConfig.${PLATFORM} ${PLATFORM}/inc/buildConfig.h

rm -rf win-i686-debug/inc/sqlite3.h
cp -r src/sqlite3.h win-i686-debug/inc/sqlite3.h

"${CC}" -c -Fo${PLATFORM}/obj/sqlite.obj -Fd${PLATFORM}/obj ${CFLAGS} ${DFLAGS} -I${PLATFORM}/inc src/sqlite.c

"${CC}" -c -Fo${PLATFORM}/obj/sqlite3.obj -Fd${PLATFORM}/obj ${CFLAGS} ${DFLAGS} -I${PLATFORM}/inc src/sqlite3.c

"${LD}" -dll -out:${PLATFORM}/bin/libsqlite3.dll -entry:_DllMainCRTStartup@12 -def:${PLATFORM}/bin/libsqlite3.def ${LDFLAGS} ${LIBPATHS} ${PLATFORM}/obj/sqlite.obj ${PLATFORM}/obj/sqlite3.obj ${LIBS}

