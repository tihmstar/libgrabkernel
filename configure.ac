AC_PREREQ([2.69])
AC_INIT([libgrabkernel], m4_esyscmd([git rev-list --count HEAD | tr -d '\n']), [tihmstar@gmail.com])

AC_CANONICAL_SYSTEM

AC_CANONICAL_HOST
# Check for operating system
AC_MSG_CHECKING([whether we need platform-specific build settings])

AC_CONFIG_SRCDIR([config.h.in])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIRS([m4])
AM_PROG_LIBTOOL
AM_INIT_AUTOMAKE

OBJCFLAGS+=" -D LIBGRABKERNEL_VERSION_COMMIT_COUNT=\\\"$(git rev-list --count HEAD | tr -d '\n')\\\""
OBJCFLAGS+=" -D LIBGRABKERNEL_VERSION_COMMIT_SHA=\\\"$(git rev-parse HEAD | tr -d '\n')\\\""

# Checks for programs.
AC_PROG_CC
AC_PROG_OBJC

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h stdint.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_INT64_T
AC_TYPE_INT8_T
AC_TYPE_SIZE_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_FUNC_MALLOC

LT_INIT

AC_CONFIG_FILES([Makefile
                 include/Makefile
                 libgrabkernel/Makefile
		 libgrabkernel.pc])
AC_OUTPUT
