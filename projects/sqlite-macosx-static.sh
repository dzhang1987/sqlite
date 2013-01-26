#
#   sqlite-macosx-static.sh -- Build It Shell Script to build SQLite Library
#

PRODUCT="sqlite"
VERSION="1.0.0"
BUILD_NUMBER="0"
PROFILE="static"
ARCH="x64"
ARCH="`uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/'`"
OS="macosx"
CONFIG="${OS}-${ARCH}-${PROFILE}"
CC="/usr/bin/clang"
LD="/usr/bin/ld"
CFLAGS="-O3   -w"
DFLAGS="-DBIT_FEATURE_SQLITE=1"
IFLAGS="-I${CONFIG}/inc"
LDFLAGS="-Wl,-rpath,@executable_path/ -Wl,-rpath,@loader_path/"
LIBPATHS="-L${CONFIG}/bin"
LIBS="-lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin

[ ! -f ${CONFIG}/inc/bit.h ] && cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
[ ! -f ${CONFIG}/inc/bitos.h ] && cp ${SRC}/src/bitos.h ${CONFIG}/inc/bitos.h
if ! diff ${CONFIG}/inc/bit.h projects/sqlite-${OS}-${PROFILE}-bit.h >/dev/null ; then
	cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
fi

rm -rf ${CONFIG}/inc/sqlite3.h
cp -r src/sqlite3.h ${CONFIG}/inc/sqlite3.h

${CC} -c -o ${CONFIG}/obj/sqlite.o -arch x86_64 -O3 ${DFLAGS} -I${CONFIG}/inc src/sqlite.c

${CC} -c -o ${CONFIG}/obj/sqlite3.o -arch x86_64 -O3 ${DFLAGS} -I${CONFIG}/inc src/sqlite3.c

/usr/bin/ar -cr ${CONFIG}/bin/libsqlite3.a ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o

#  Omit build script undefined
