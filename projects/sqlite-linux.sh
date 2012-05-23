#
#   sqlite-linux.sh -- Build It Shell Script to build SQLite Library
#

ARCH="x86"
ARCH="$(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/')"
OS="linux"
PROFILE="debug"
CONFIG="${OS}-${ARCH}-${PROFILE}"
CC="/usr/bin/gcc"
LD="/usr/bin/ld"
CFLAGS="-Wall -fPIC -g -Wshorten-64-to-32 -mtune=generic"
DFLAGS="-D_REENTRANT -DBIT_FEATURE_SQLITE=1 -DPIC -DBIT_DEBUG"
IFLAGS="-I${CONFIG}/inc"
LDFLAGS="-Wl,--enable-new-dtags -Wl,-rpath,\$ORIGIN/ -Wl,-rpath,\$ORIGIN/../bin -rdynamic -g"
LIBPATHS="-L${CONFIG}/bin"
LIBS="-lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin

[ ! -f ${CONFIG}/inc/bit.h ] && cp projects/sqlite-${OS}-bit.h ${CONFIG}/inc/bit.h
if ! diff ${CONFIG}/inc/bit.h projects/sqlite-${OS}-bit.h >/dev/null ; then
	cp projects/sqlite-${OS}-bit.h ${CONFIG}/inc/bit.h
fi

rm -rf ${CONFIG}/inc/sqlite3.h
cp -r src/sqlite3.h ${CONFIG}/inc/sqlite3.h

${CC} -c -o ${CONFIG}/obj/sqlite.o -fPIC -g -mtune=generic ${DFLAGS} -I${CONFIG}/inc src/sqlite.c

${CC} -c -o ${CONFIG}/obj/sqlite3.o -fPIC -g -mtune=generic ${DFLAGS} -I${CONFIG}/inc src/sqlite3.c

${CC} -shared -o ${CONFIG}/bin/libsqlite3.so ${LDFLAGS} ${LIBPATHS} ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}

