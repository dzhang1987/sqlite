#
#   solaris-i686-debug.sh -- Build It Shell Script to build SQLite Library
#

CONFIG="solaris-i686-debug"
CC="cc"
LD="ld"
CFLAGS="-Wall -fPIC -O3 -mcpu=i686 -fPIC -O3 -mcpu=i686"
DFLAGS="-D_REENTRANT -DCPU=${ARCH} -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC"
IFLAGS="-Isolaris-i686-debug/inc -Isolaris-i686-debug/inc"
LDFLAGS=""
LIBPATHS="-L${CONFIG}/lib -L${CONFIG}/lib"
LIBS="-llxnet -lrt -lsocket -lpthread -lm -lpthread -lm"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin
cp projects/buildConfig.${CONFIG} ${CONFIG}/inc/buildConfig.h

rm -rf solaris-i686-debug/inc/sqlite3.h
cp -r src/sqlite3.h solaris-i686-debug/inc/sqlite3.h

${LDFLAGS}${LDFLAGS}${CC} -c -o ${CONFIG}/obj/sqlite.o -fPIC -O3 -mcpu=i686 -fPIC -O3 -mcpu=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite.c

${LDFLAGS}${LDFLAGS}${CC} -c -o ${CONFIG}/obj/sqlite3.o -fPIC -O3 -mcpu=i686 -fPIC -O3 -mcpu=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite3.c

${LDFLAGS}${LDFLAGS}${CC} -shared -o ${CONFIG}/lib/libsqlite3.so ${LIBPATHS} ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}

