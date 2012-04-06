#
#   win-i686-debug.sh -- Build It Shell Script to build SQLite Library
#

VS="${VSINSTALLDIR}"
: ${VS:="$(VS)"}
SDK="${WindowsSDKDir}"
: ${SDK:="$(SDK)"}

export SDK VS
export PATH="$(SDK)/Bin:$(VS)/VC/Bin:$(VS)/Common7/IDE:$(VS)/Common7/Tools:$(VS)/SDK/v3.5/bin:$(VS)/VC/VCPackages;$(PATH)"
export INCLUDE="$(INCLUDE);$(SDK)/INCLUDE:$(VS)/VC/INCLUDE"
export LIB="$(LIB);$(SDK)/lib:$(VS)/VC/lib"

CONFIG="win-i686-debug"
CC="cl.exe"
LD="link.exe"
CFLAGS="-nologo -GR- -W3 -Zi -Od -MDd -Zi -Od -MDd"
DFLAGS="-D_REENTRANT -D_MT -DBLD_FEATURE_SQLITE=1"
IFLAGS="-Iwin-i686-debug/inc -Iwin-i686-debug/inc"
LDFLAGS="-nologo -nodefaultlib -incremental:no -machine:x86 -machine:x86"
LIBPATHS="-libpath:${CONFIG}/bin -libpath:${CONFIG}/bin"
LIBS="ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib shell32.lib"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin
cp projects/buildConfig.${CONFIG} ${CONFIG}/inc/buildConfig.h

rm -rf win-i686-debug/inc/sqlite3.h
cp -r src/sqlite3.h win-i686-debug/inc/sqlite3.h

"${CC}" -c -Fo${CONFIG}/obj/sqlite.obj -Fd${CONFIG}/obj ${CFLAGS} ${DFLAGS} -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite.c

"${CC}" -c -Fo${CONFIG}/obj/sqlite3.obj -Fd${CONFIG}/obj ${CFLAGS} ${DFLAGS} -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite3.c

"${LD}" -dll -out:${CONFIG}/bin/libsqlite3.dll -entry:_DllMainCRTStartup@12 -def:${CONFIG}/bin/libsqlite3.def ${LDFLAGS} ${LIBPATHS} ${CONFIG}/obj/sqlite.obj ${CONFIG}/obj/sqlite3.obj ${LIBS}

