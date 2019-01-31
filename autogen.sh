#!/bin/bash

gprefix=`which glibtoolize 2>&1 >/dev/null`
if [ $? -eq 0 ]; then
  glibtoolize --force
else
  libtoolize --force
fi
aclocal -I m4
autoconf
autoheader
automake --add-missing


SYSROOT="$(xcrun --show-sdk-path --sdk iphoneos)"
export CFLAGS+="-arch arm64 -isysroot $SYSROOT -I$PWD/deps/curl-static/"
export CXXFLAGS+="-arch arm64 -isysroot $SYSROOT -I$PWD/deps/curl-static/"
export OBJCFLAGS+="-arch arm64 -isysroot $SYSROOT -I$PWD/deps/curl-static/"
export LDFLAGS+="-L$PWD/deps/curl-static"


CONFIGURE_FLAGS="--enable-static --disable-shared\
  --build=x86_64-apple-darwin`uname -r` \
  --host=aarch64-apple-darwin \
  $@"

SUBDIRS="external/libfragmentzip"
for SUB in $SUBDIRS; do
    pushd $SUB
    ./autogen.sh $CONFIGURE_FLAGS
    popd
done

./configure $CONFIGURE_FLAGS

