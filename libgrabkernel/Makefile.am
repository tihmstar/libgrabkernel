AM_CFLAGS = -I$(top_srcdir)/include $(GLOBAL_CFLAGS) $(libfragmentzip_CFLAGS) $(libgeneral_CFLAGS)
AM_CXXFLAGS = $(AM_CFLAGS) $(GLOBAL_CXXFLAGS)
AM_OBJCFLAGS = $(AM_CFLAGS) $(GLOBAL_OBJCFLAGS)
AM_LDFLAGS = $(libfragmentzip_LIBS)

lib_LTLIBRARIES = libgrabkernel.la 

libgrabkernel_la_CFLAGS = $(AM_CFLAGS)
libgrabkernel_la_CXXFLAGS = $(AM_CXXFLAGS)
libgrabkernel_la_OBJCFLAGS = $(AM_OBJCFLAGS)
libgrabkernel_la_LIBADD = $(AM_LDFLAGS)
libgrabkernel_la_SOURCES = libgrabkernel.m
