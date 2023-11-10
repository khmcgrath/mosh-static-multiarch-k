#!/bin/bash

set -e

protobuf_LIBS=$(l=libprotobuf.a; for i in /opt/local/lib /usr/local/lib; do  if [ -f $i/$l ]; then echo $i/$l; fi; done)
if [ -z "$protobuf_LIBS" ]; then echo "Can't find libprotobuf.a"; exit 1; fi
export protobuf_LIBS
if ! pkg-config --cflags protobuf > /dev/null 2>&1; then
    protobuf_CFLAGS=-I$(for i in /opt /usr; do d=$i/local/include; if [ -d $d/google/protobuf ]; then echo $d; fi; done)
    if [ "$protobuf_CFLAGS" = "-I" ]; then echo "Can't find protobuf includes"; exit 1; fi
    export protobuf_CFLAGS
fi
export CXXFLAGS=-std=gnu++17

# XXX This script abuses Configure's --prefix argument badly.  It uses
# it as a $DESTDIR, but --prefix can also affect paths in generated
# objects.  That is not *currently* a problem in mosh.
#
PREFIX="$(pwd)/prefix"

HOST="x86_64-apple-macosx${MACOSX_DEPLOYMENT_TARGET}"
ARCH_TRIPLES="x86_64-apple-macosx arm64-apple-macos"

pushd ../mosh > /dev/null

if [ ! -f configure ];
then
    echo "Running autogen."
    PATH=/opt/local/bin:$PATH ./autogen.sh
fi

#
# Build archs one by one.
#
for triple in $ARCH_TRIPLES; do
    arch=$(echo $triple | cut -d- -f1)
    echo "Building for ${arch}..."
    prefix="${PREFIX}_${arch}"
    rm -rf "${prefix}"
    mkdir "${prefix}"
    if ./configure --prefix="${prefix}/local" --build="${triple}${MACOSX_DEPLOYMENT_TARGET}"\
           --host="${HOST}" \
           CC="cc -arch ${arch}" CPP="cc -arch ${arch} -E" CXX="c++ -arch ${arch}" \
           TINFO_LIBS=-lncurses &&
        make clean &&
        make install -j8 V=1 &&
        rm -f "${prefix}/etc"
    then
    mv "${prefix}/local/bin/mosh-client" "${prefix}/local/bin/mosh-client-${MOSH_TAG}-darwin-${arch}"
    mv "${prefix}/local/bin/mosh-server" "${prefix}/local/bin/mosh-server-${MOSH_TAG}-darwin-${arch}"

    BUILT_ARCHS="$BUILT_ARCHS $arch"
    fi
done

if [ -z "$BUILT_ARCHS" ]; then
    echo "No architectures built successfully"
    exit 1
fi

popd > /dev/null
