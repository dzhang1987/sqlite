#
#   macosx-x86_64-debug.sh -- Build It Shell Script to build SQLite Library
#

CONFIG="macosx-x86_64-debug"
CC="/usr/bin/cc"
LD="/usr/bin/ld"
CFLAGS="-fPIC -Wall -fast -Wshorten-64-to-32"
DFLAGS="-DPIC -DBLD_FEATURE_SQLITE=1 -DCPU=X86_64"
IFLAGS="-Imacosx-x86_64-debug/inc -Imacosx-x86_64-debug/inc"
LDFLAGS="-Wl,-rpath,@executable_path/../lib -Wl,-rpath,@executable_path/ -Wl,-rpath,@loader_path/"
LIBPATHS="-L${CONFIG}/lib"
LIBS="-lpthread -lm -ldl"

[ ! -x ${CONFIG}/inc ] && mkdir -p ${CONFIG}/inc ${CONFIG}/obj ${CONFIG}/lib ${CONFIG}/bin
cp projects/buildConfig.${CONFIG} ${CONFIG}/inc/buildConfig.h

rm -rf macosx-x86_64-debug/inc/sqlite3.h
cp -r src/sqlite3.h macosx-x86_64-debug/inc/sqlite3.h

${CC} -c -o ${CONFIG}/obj/sqlite.o -arch x86_64 -fPIC -fast ${DFLAGS} -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite.c

${CC} -c -o ${CONFIG}/obj/sqlite3.o -arch x86_64 -fPIC -fast ${DFLAGS} -I${CONFIG}/inc -I${CONFIG}/inc src/sqlite3.c

${CC} -dynamiclib -o ${CONFIG}/lib/libsqlite3.dylib -arch x86_64 ${LDFLAGS} ${LIBPATHS} -install_name @rpath/libsqlite3.dylib ${CONFIG}/obj/sqlite.o ${CONFIG}/obj/sqlite3.o ${LIBS}

