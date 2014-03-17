/*
    me.h -- MakeMe Configuration Header for windows-x86-default

    This header is created by Me during configuration. To change settings, re-run
    configure or define variables in your Makefile to override these default values.
 */

/* Settings */
#ifndef ME_AUTHOR
    #define ME_AUTHOR "Embedthis Software"
#endif
#ifndef ME_COMPANY
    #define ME_COMPANY "embedthis"
#endif
#ifndef ME_COMPATIBLE
    #define ME_COMPATIBLE "1.0.2"
#endif
#ifndef ME_DEBUG
    #define ME_DEBUG 1
#endif
#ifndef ME_DEPTH
    #define ME_DEPTH 1
#endif
#ifndef ME_DESCRIPTION
    #define ME_DESCRIPTION "SQLite Library"
#endif
#ifndef ME_EXTENSIONS_DISCOVER
    #define ME_EXTENSIONS_DISCOVER ""
#endif
#ifndef ME_EXTENSIONS_OMIT
    #define ME_EXTENSIONS_OMIT ""
#endif
#ifndef ME_EXTENSIONS_REQUIRE
    #define ME_EXTENSIONS_REQUIRE "winsdk,compiler,lib,link,rc"
#endif
#ifndef ME_HAS_ATOMIC
    #define ME_HAS_ATOMIC 0
#endif
#ifndef ME_HAS_ATOMIC64
    #define ME_HAS_ATOMIC64 0
#endif
#ifndef ME_HAS_DYN_LOAD
    #define ME_HAS_DYN_LOAD 1
#endif
#ifndef ME_HAS_LIB_EDIT
    #define ME_HAS_LIB_EDIT 0
#endif
#ifndef ME_HAS_LIB_RT
    #define ME_HAS_LIB_RT 0
#endif
#ifndef ME_HAS_MMU
    #define ME_HAS_MMU 1
#endif
#ifndef ME_HAS_STACK_PROTECTOR
    #define ME_HAS_STACK_PROTECTOR 0
#endif
#ifndef ME_HAS_SYNC
    #define ME_HAS_SYNC 0
#endif
#ifndef ME_HAS_SYNC64
    #define ME_HAS_SYNC64 0
#endif
#ifndef ME_HAS_SYNC_CAS
    #define ME_HAS_SYNC_CAS 0
#endif
#ifndef ME_HAS_UNNAMED_UNIONS
    #define ME_HAS_UNNAMED_UNIONS 1
#endif
#ifndef ME_MAKEME
    #define ME_MAKEME "0.8.0"
#endif
#ifndef ME_NAME
    #define ME_NAME "sqlite"
#endif
#ifndef ME_PREFIXES
    #define ME_PREFIXES "package-prefixes"
#endif
#ifndef ME_TITLE
    #define ME_TITLE "SQLite Library"
#endif
#ifndef ME_VERSION
    #define ME_VERSION "1.0.2"
#endif

/* Prefixes */
#ifndef ME_ROOT_PREFIX
    #define ME_ROOT_PREFIX "C:"
#endif
#ifndef ME_PROGRAMFILES_PREFIX
    #define ME_PROGRAMFILES_PREFIX "C:/Program Files"
#endif
#ifndef ME_PROGRAMFILES32_PREFIX
    #define ME_PROGRAMFILES32_PREFIX "C:/Program Files"
#endif
#ifndef ME_BASE_PREFIX
    #define ME_BASE_PREFIX "C:/Program Files"
#endif
#ifndef ME_APP_PREFIX
    #define ME_APP_PREFIX "C:/Program Files/SQLite Library"
#endif
#ifndef ME_VAPP_PREFIX
    #define ME_VAPP_PREFIX "C:/Program Files/SQLite Library"
#endif
#ifndef ME_DATA_PREFIX
    #define ME_DATA_PREFIX "C:/Program Files/SQLite Library"
#endif
#ifndef ME_STATE_PREFIX
    #define ME_STATE_PREFIX "C:/Program Files/SQLite Library"
#endif
#ifndef ME_BIN_PREFIX
    #define ME_BIN_PREFIX "C:/Program Files/SQLite Library/bin"
#endif
#ifndef ME_INC_PREFIX
    #define ME_INC_PREFIX "C:/Program Files/SQLite Library/inc"
#endif
#ifndef ME_LIB_PREFIX
    #define ME_LIB_PREFIX "C:/Program Files/SQLite Library/lib"
#endif
#ifndef ME_MAN_PREFIX
    #define ME_MAN_PREFIX "C:/Program Files/SQLite Library/man"
#endif
#ifndef ME_ETC_PREFIX
    #define ME_ETC_PREFIX "C:/Program Files/SQLite Library"
#endif
#ifndef ME_WEB_PREFIX
    #define ME_WEB_PREFIX "C:/Program Files/SQLite Library/web"
#endif
#ifndef ME_LOG_PREFIX
    #define ME_LOG_PREFIX "C:/Program Files/SQLite Library/log"
#endif
#ifndef ME_SPOOL_PREFIX
    #define ME_SPOOL_PREFIX "C:/Program Files/SQLite Library/tmp"
#endif
#ifndef ME_CACHE_PREFIX
    #define ME_CACHE_PREFIX "C:/Program Files/SQLite Library/cache"
#endif
#ifndef ME_SRC_PREFIX
    #define ME_SRC_PREFIX "C:/Program Files/SQLite Library/src"
#endif

/* Suffixes */
#ifndef ME_EXE
    #define ME_EXE ".exe"
#endif
#ifndef ME_SHLIB
    #define ME_SHLIB ".lib"
#endif
#ifndef ME_SHOBJ
    #define ME_SHOBJ ".dll"
#endif
#ifndef ME_LIB
    #define ME_LIB ".lib"
#endif
#ifndef ME_OBJ
    #define ME_OBJ ".obj"
#endif

/* Profile */
#ifndef ME_CONFIG_CMD
    #define ME_CONFIG_CMD "me -d -q -platform windows-x86-default -configure . -gen vs"
#endif
#ifndef ME_SQLITE_PRODUCT
    #define ME_SQLITE_PRODUCT 1
#endif
#ifndef ME_PROFILE
    #define ME_PROFILE "default"
#endif
#ifndef ME_TUNE_SIZE
    #define ME_TUNE_SIZE 1
#endif

/* Miscellaneous */
#ifndef ME_MAJOR_VERSION
    #define ME_MAJOR_VERSION 1
#endif
#ifndef ME_MINOR_VERSION
    #define ME_MINOR_VERSION 0
#endif
#ifndef ME_PATCH_VERSION
    #define ME_PATCH_VERSION 2
#endif
#ifndef ME_VNUM
    #define ME_VNUM 100000002
#endif

/* Extensions */
#ifndef ME_EXT_CC
    #define ME_EXT_CC 1
#endif
#ifndef ME_EXT_LIB
    #define ME_EXT_LIB 1
#endif
#ifndef ME_EXT_LINK
    #define ME_EXT_LINK 1
#endif
#ifndef ME_EXT_RC
    #define ME_EXT_RC 0
#endif
#ifndef ME_EXT_VXWORKS
    #define ME_EXT_VXWORKS 1
#endif
#ifndef ME_EXT_WINSDK
    #define ME_EXT_WINSDK 0
#endif
