AM_CFLAGS = -I$(top_srcdir)/include -I$(top_srcdir)/include/libgrabkernel -I$(top_srcdir)/external/libfragmentzip/include
AM_LDFLAGS = -L/usr/local/lib/

lib_LTLIBRARIES = libgrabkernel.la 

libgrabkernel_la_CPPFLAGS = $(AM_CFLAGS)
libgrabkernel_la_LIBADD = $(AM_LDFLAGS)
libgrabkernel_la_SOURCES = libgrabkernel.c
