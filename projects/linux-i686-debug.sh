#
#   linux-i686-debug.sh -- Build It Shell Script to build SQLite Library
#

CONFIG="linux-i686-debug"
CC="cc"
LD="ld"
CFLAGS="-Wall -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686"
DFLAGS="-D_REENTRANT -DCPU=${ARCH} -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC"
IFLAGS="-Ilinux-i686-debug/inc -Ilinux-i686-debug/inc"
LDFLAGS="-Wl,--enable-new-dtags -Wl,-rpath,\$ORIGIN/ -Wl,-rpath,\$ORIGIN/../lib"
LIBPATHS="-L${CONFIG}/lib -L${CONFIG}/lib"
LIBS="-lpthread -lm -ldl -lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin
cp projects/buildConfig.${CONFIG} ${CONFIG}/inc/buildConfig.h

rm -rf linux-i686-debug/inc/sqlite3.h
cp -r src/sqlite3.h linux-i686-debug/inc/sqlite3.h

${CC} -c -o ${CONFIG}/obj/sqlite.o -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite.c

${CC} -c -o ${CONFIG}/obj/sqlite3.o -fPIC -O3 -Wno-unused-result -mtune=i686 -fPIC -O3 -Wno-unused-result -mtune=i686 -D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC -DPIC -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite3.c

${CC} -shared -o ${CONFIG}/lib/libsqlite3.so ${LDFLAGS} ${LIBPATHS} ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}

