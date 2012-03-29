#
#   macosx-x86_64-debug.sh -- Build It Shell Script to build SQLite Library
#

PLATFORM="macosx-x86_64-debug"
CC="cc"
LD="ld"
CFLAGS="-fPIC -Wall -g"
DFLAGS="-DPIC -DBLD_FEATURE_SQLITE=1 -DCPU=X86_64"
IFLAGS="-Imacosx-x86_64-debug/inc"
LDFLAGS="-Wl,-rpath,@executable_path/../lib -Wl,-rpath,@executable_path/ -Wl,-rpath,@loader_path/ -g -ldl"
LIBPATHS="-L${PLATFORM}/lib"
LIBS="-lpthread -lm"

[ ! -x ${PLATFORM}/inc ] && mkdir -p ${PLATFORM}/inc ${PLATFORM}/obj ${PLATFORM}/lib ${PLATFORM}/bin
[ ! -f ${PLATFORM}/inc/buildConfig.h ] && cp projects/buildConfig.${PLATFORM} ${PLATFORM}/inc/buildConfig.h

rm -rf macosx-x86_64-debug/inc/sqlite3.h
cp -r src/sqlite3.h macosx-x86_64-debug/inc/sqlite3.h

${CC} -c -o ${PLATFORM}/obj/sqlite.o -arch x86_64 -fPIC -g ${DFLAGS} -I${PLATFORM}/inc src/sqlite.c

${CC} -c -o ${PLATFORM}/obj/sqlite3.o -arch x86_64 -fPIC -g ${DFLAGS} -I${PLATFORM}/inc src/sqlite3.c

${CC} -dynamiclib -o ${PLATFORM}/lib/libsqlite3.dylib -arch x86_64 ${LDFLAGS} ${LIBPATHS} -install_name @rpath/libsqlite3.dylib ${PLATFORM}/obj/sqlite.o ${PLATFORM}/obj/sqlite3.o ${LIBS}

