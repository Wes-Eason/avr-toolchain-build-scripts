#!/bin/bash
# Download and build the latest version of the GNU Compiler Collection for
# AVR targets
#
# TODO: Consider using a mirror before publishing this script


# Download or Extract
# ==========================================================

set -e

# Determine latest version
gcc_version="$(svn ls svn://gcc.gnu.org/svn/gcc/tags | grep release | grep ^gcc_ | sort | tail -n 1 | sed 's;\(.*\)/;\1;g')"

source_dir="$PWD/$gcc_version"
source_archive="$source_archive_dir/$gcc_version.tar.gz"

# Extract latest gcc if already on system, otherwise download it
if [ ! -d "$source_dir" ]; then
    if [ -f "$source_archive" ]; then
        mkdir "$source_dir"
        tar -xf "$source_archive" -C "$source_dir" --strip-components 1

    else
        svn checkout "svn://gcc.gnu.org/svn/gcc/tags/$gcc_version" "$source_dir"

        tar -c "$source_dir" | gzip > "$source_archive"
    fi
fi

# Build
# ==========================================================
pushd "$source_dir"
contrib/download_prerequisites
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PWD/mpc/src"
export C_INCLUDE_PATH="$C_INCLUDE_PATH:$PWD/mpc/src"
popd

#Srm -rf gcc-build-avr
if [ ! -d gcc-build-avr ]; then
    mkdir gcc-build-avr
fi
pushd gcc-build-avr

$source_dir/configure \
    --prefix="$pkgroot$install_prefix" \
    --target=avr \
    --enable-languages=c,c++ \
    --disable-nls \
    --disable-libssp \
    --with-dwarf2

make
make install

popd
