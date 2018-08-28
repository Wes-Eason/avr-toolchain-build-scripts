#!/bin/bash
# Compile and install binutils
# TODO: Automatically download the latest version of binutils

set -e

declare -a to_clean

name="binutils-2.30"
source_dir="$name"
source_archive="$source_archive_dir/$name.tar.gz"

# Extract
# ==========================================================
if [ ! -d "$source_dir" ]; then
    tar -xf "$source_archive"
fi
pushd "$source_dir"

# Build
# ==========================================================
if [ ! -d build ]; then
     mkdir build
fi
pushd build

../configure \
    --target=avr \
    --prefix="$pkgroot$install_prefix" \
    --disable-nls

make
make install

popd
popd
