#
#   macosx-x86_64-debug.sh -- Build It Shell Script to build SQLite Library
#

OS="macosx"
CONFIG="${OS}-x86_64-debug"
CC="/usr/bin/clang"
LD="/usr/bin/ld"
CFLAGS="-Wall -g -Wno-unused-result -Wshorten-64-to-32"
DFLAGS="-DBLD_FEATURE_SQLITE=1 -DBLD_DEBUG"
IFLAGS="-I${CONFIG}/inc"
LDFLAGS="-Wl,-rpath,@executable_path/../lib -Wl,-rpath,@executable_path/ -Wl,-rpath,@loader_path/ -g"
LIBPATHS="-L${CONFIG}/lib"
LIBS="-lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin

[ ! -f ${CONFIG}/inc/bit.h ] && cp projects/sqlite-${OS}-bit.h ${CONFIG}/inc/bit.h
if ! diff ${CONFIG}/inc/bit.h projects/sqlite-${OS}-bit.h >/dev/null ; then
	cp projects/sqlite-${OS}-bit.h ${CONFIG}/inc/bit.h
fi

rm -rf ${CONFIG}/inc/sqlite3.h
cp -r src/sqlite3.h ${CONFIG}/inc/sqlite3.h

${CC} -c -o ${CONFIG}/obj/sqlite.o -arch x86_64 -g -Wno-unused-result ${DFLAGS} -I${CONFIG}/inc src/sqlite.c

${CC} -c -o ${CONFIG}/obj/sqlite3.o -arch x86_64 -g -Wno-unused-result ${DFLAGS} -I${CONFIG}/inc src/sqlite3.c

${CC} -dynamiclib -o ${CONFIG}/lib/libsqlite3.dylib -arch x86_64 ${LDFLAGS} ${LIBPATHS} -install_name @rpath/libsqlite3.dylib ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}
