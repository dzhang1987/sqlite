#
#   sqlite-windows-default.sh -- Build It Shell Script to build SQLite Library
#

export PATH="$(SDK)/Bin:$(VS)/VC/Bin:$(VS)/Common7/IDE:$(VS)/Common7/Tools:$(VS)/SDK/v3.5/bin:$(VS)/VC/VCPackages;$(PATH)"
export INCLUDE="$(INCLUDE);$(SDK)/Include:$(VS)/VC/INCLUDE"
export LIB="$(LIB);$(SDK)/Lib:$(VS)/VC/lib"

PRODUCT="sqlite"
VERSION="1.0.0"
BUILD_NUMBER="0"
PROFILE="default"
ARCH="x86"
ARCH="`uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/'`"
OS="windows"
CONFIG="${OS}-${ARCH}-${PROFILE}"
CC="cl.exe"
LD="link.exe"
CFLAGS="-nologo -GR- -W3 -O2 -MD -w"
DFLAGS="-D_REENTRANT -D_MT -DBIT_FEATURE_SQLITE=1"
IFLAGS="-I${CONFIG}/inc"
LDFLAGS="-nologo -nodefaultlib -incremental:no -machine:x86"
LIBPATHS="-libpath:${CONFIG}/bin"
LIBS="ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib shell32.lib"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin

[ ! -f ${CONFIG}/inc/bit.h ] && cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
[ ! -f ${CONFIG}/inc/bitos.h ] && cp ${SRC}/src/bitos.h ${CONFIG}/inc/bitos.h
if ! diff ${CONFIG}/inc/bit.h projects/sqlite-${OS}-${PROFILE}-bit.h >/dev/null ; then
	cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
fi

rm -rf ${CONFIG}/inc/sqlite3.h
cp -r src/sqlite3.h ${CONFIG}/inc/sqlite3.h

"${CC}" -c -Fo${CONFIG}/obj/sqlite.obj -Fd${CONFIG}/obj/sqlite.pdb ${CFLAGS} ${DFLAGS} -I${CONFIG}/inc src/sqlite.c

"${CC}" -c -Fo${CONFIG}/obj/sqlite3.obj -Fd${CONFIG}/obj/sqlite3.pdb ${CFLAGS} ${DFLAGS} -I${CONFIG}/inc src/sqlite3.c

"${LD}" -dll -out:${CONFIG}/bin/libsqlite3.dll -entry:_DllMainCRTStartup@12 ${LDFLAGS} ${LIBPATHS} ${CONFIG}/obj/sqlite.obj ${CONFIG}/obj/sqlite3.obj ${LIBS}

#  Omit build script undefined
