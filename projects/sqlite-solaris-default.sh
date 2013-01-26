#
#   sqlite-solaris-default.sh -- Build It Shell Script to build SQLite Library
#

PRODUCT="sqlite"
VERSION="1.0.0"
BUILD_NUMBER="0"
PROFILE="default"
ARCH="x86"
ARCH="`uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/'`"
OS="solaris"
CONFIG="${OS}-${ARCH}-${PROFILE}"
CC="/usr/bin/gcc"
LD="/usr/bin/ld"
CFLAGS="-fPIC -O2 -w"
DFLAGS="-D_REENTRANT -DBIT_FEATURE_SQLITE=1 -DPIC"
IFLAGS="-I${CONFIG}/inc"
LDFLAGS=""
LIBPATHS="-L${CONFIG}/bin"
LIBS="-llxnet -lrt -lsocket -lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin

[ ! -f ${CONFIG}/inc/bit.h ] && cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
[ ! -f ${CONFIG}/inc/bitos.h ] && cp ${SRC}/src/bitos.h ${CONFIG}/inc/bitos.h
if ! diff ${CONFIG}/inc/bit.h projects/sqlite-${OS}-${PROFILE}-bit.h >/dev/null ; then
	cp projects/sqlite-${OS}-${PROFILE}-bit.h ${CONFIG}/inc/bit.h
fi

rm -rf ${CONFIG}/inc/sqlite3.h
cp -r src/sqlite3.h ${CONFIG}/inc/sqlite3.h

${LDFLAGS}${LDFLAGS}${CC} -c -o ${CONFIG}/obj/sqlite.o -fPIC -O2 ${DFLAGS} -I${CONFIG}/inc src/sqlite.c

${LDFLAGS}${LDFLAGS}${CC} -c -o ${CONFIG}/obj/sqlite3.o -fPIC -O2 ${DFLAGS} -I${CONFIG}/inc src/sqlite3.c

${LDFLAGS}${LDFLAGS}${CC} -shared -o ${CONFIG}/bin/libsqlite3.so ${LIBPATHS} ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}

#  Omit build script undefined
