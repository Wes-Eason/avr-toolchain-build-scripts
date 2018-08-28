#!/bin/bash
# Compile and Build AVR-LibC

set -e

version="2.0.0"

# Extract
# ==========================================================
source_archive="$source_archive_dir/avr-libc-$version.tar.bz2"

if [ ! -d "avr-libc-$version" ]; then
    bunzip2 -c "$source_archive" | tar -xf -
fi


# Build
# ==========================================================
pushd "avr-libc-$version"
./configure \
--prefix="$pkgroot$install_prefix" \
--build=`./config.guess` \
--host=avr \
--with-debug-info=DEBUG_INFO
make
make install
popd
