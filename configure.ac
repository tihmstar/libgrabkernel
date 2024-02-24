AC_PREREQ([2.69])
AC_INIT([libgrabkernel], m4_esyscmd([git rev-list --count HEAD | tr -d '\n']), [tihmstar@gmail.com])

AC_CANONICAL_SYSTEM
AC_CANONICAL_HOST
AM_PROG_LIBTOOL

AM_INIT_AUTOMAKE([subdir-objects])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIRS([m4])
AC_CANONICAL_SYSTEM

AC_DEFINE([VERSION_COMMIT_COUNT], "m4_esyscmd([git rev-list --count HEAD | tr -d '\n'])", [Git commit count])
AC_DEFINE([VERSION_COMMIT_SHA], "m4_esyscmd([git rev-parse HEAD | tr -d '\n'])", [Git commit sha])
AC_SUBST([VERSION_COMMIT_COUNT], ["m4_esyscmd([git rev-list --count HEAD | tr -d '\n'])"])
AC_SUBST([VERSION_COMMIT_SHA], ["m4_esyscmd([git rev-parse HEAD | tr -d '\n'])"])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_OBJC

CXXFLAGS+=" -std=c++11"
CFLAGS+=" -std=c11"

# Checks for libraries.
LIBFRAGMENTZIP_REQUIRES_STR="libfragmentzip >= 68"
LIBGENERAL_REQUIRES_STR="libgeneral >= 75"
PKG_CHECK_MODULES(libfragmentzip, $LIBFRAGMENTZIP_REQUIRES_STR)
PKG_CHECK_MODULES(libgeneral, $LIBGENERAL_REQUIRES_STR)

AC_SUBST([libfragmentzip_requires], [$LIBFRAGMENTZIP_REQUIRES_STR])

AC_ARG_ENABLE([debug],
            [AS_HELP_STRING([--enable-debug],
            [enable debug build(default is no)])],
            [debug_build=true],
            [debug_build=false])


AC_CONFIG_FILES([Makefile
                 include/Makefile
                 libgrabkernel/Makefile
		         libgrabkernel.pc])
AC_OUTPUT
