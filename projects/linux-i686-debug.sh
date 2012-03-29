#
#   linux-i686-debug.sh -- Build It Shell Script to build SQLite Library
#

PLATFORM="linux-i686-debug"
CC="cc"
LD="ld"
CFLAGS="-Wall -fPIC -g -Wno-unused-result -mtune=i686"
DFLAGS="-D_REENTRANT -DCPU=i686 -DBLD_FEATURE_SQLITE=1 -DPIC"
IFLAGS="-Ilinux-i686-debug/inc"
LDFLAGS="-Wl,--enable-new-dtags -Wl,-rpath,\$ORIGIN/ -Wl,-rpath,\$ORIGIN/../lib -g"
LIBPATHS="-L${PLATFORM}/lib"
LIBS="-lpthread -lm -ldl"

[ ! -x ${PLATFORM}/inc ] && mkdir -p ${PLATFORM}/inc ${PLATFORM}/obj ${PLATFORM}/lib ${PLATFORM}/bin
[ ! -f ${PLATFORM}/inc/buildConfig.h ] && cp projects/buildConfig.${PLATFORM} ${PLATFORM}/inc/buildConfig.h

rm -rf linux-i686-debug/inc/sqlite3.h
cp -r src/sqlite3.h linux-i686-debug/inc/sqlite3.h

${CC} -c -o ${PLATFORM}/obj/sqlite.o -fPIC -g -Wno-unused-result -mtune=i686 ${DFLAGS} -I${PLATFORM}/inc src/sqlite.c

${CC} -c -o ${PLATFORM}/obj/sqlite3.o -fPIC -g -Wno-unused-result -mtune=i686 ${DFLAGS} -I${PLATFORM}/inc src/sqlite3.c

${CC} -shared -o ${PLATFORM}/lib/libsqlite3.so ${LDFLAGS} ${LIBPATHS} ${PLATFORM}/obj/sqlite.o ${PLATFORM}/obj/sqlite3.o ${LIBS}

