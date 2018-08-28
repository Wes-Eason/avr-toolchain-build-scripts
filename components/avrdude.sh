#!/bin/bash
# Compile and build avrdude

set -e

version="6.3"

# Extract
# ==========================================================
source_archive="$source_archive_dir/avrdude-$version.tar.gz"

if [ ! -d "avrdude-$version" ]; then
    gunzip -c "$source_archive" | tar xf -
fi
pushd "avrdude-$version"


# Build
# ==========================================================
if [ ! -d obj-avr ]; then
    mkdir obj-avr
fi
pushd obj-avr

../configure --prefix="$pkgroot$install_prefix"

make
make install
popd
popd
