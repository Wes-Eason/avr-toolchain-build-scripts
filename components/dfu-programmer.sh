#!/bin/bash
# Obtain or Extract, then Build dfu-programmer

git_repo="https://github.com/dfu-programmer/dfu-programmer.git"
declare -a to_clean

to_clean+=("nosuchfile")

function on_exit() {
# Clean up on exit
    echo "Cleaning up..."

    i=0
    while [ $i -lt ${#to_clean[@]} ]; do
        item=${to_clean[$i]}

        echo "  rm -rf $item"
        rm -rf "$item"

        i=$(($i + 1))
    done
}

trap on_exit EXIT


# Extract or Download Latest Version
# ==========================================================

# Determine latest version
latest=\
"$(git ls-remote --tags "$git_repo" \
    | awk '{print $2}' \
    | sed 's/^refs\/tags\///g' \
    | sed 's/\^.*$//g' \
    | tail -n 1)"

localname="dfu-programmer-$latest"
source_archive="$source_archive_dir/$localname.tar.gz"

# Use/Extract local copy or fetch one from the git repo
if [ ! -d "$localname" ]; then
    if [ -f "$localname".tar.gz ]; then
        tar -xf "$source_archive"
    else
        # fetch from git
        mkdir "$localname"
        pushd "$localname"

        git init
        git remote add origin "$git_repo"
        git remote update
        git checkout "$latest"
        rm -rf ".git"

        popd

        # Create tarball
        tar -c "$localname" | gzip > "$source_archive"
    fi
fi


# Build
# ==========================================================
pushd "$localname"

# Build Dependencies
# ====================

# Make sure libusb-1.0 is in the build path
include_dir="$pkgroot/$install_prefix/include"
pkg_libusb="$include_dir/libusb-1.0"

if [ ! -e "$pkg_libusb" ]; then
    if [ ! -e "$include_dir" ]; then
        mkdir -p "$include_dir"
    fi

    echo "Searching for libusb-1.0"
    libusb_path="$(find /usr -type d -name "libusb-1.0" 2>/dev/null | tail -n 1)"

    if [ -z "$libusb_path" ]; then
        echo >&2 "Error: Could not locate libusb $libusb_path"
        exit 1
    fi

    echo "libusb-1.0 found at $libusb_path"


    to_clean+=("$pkg_libusb")
    ln -s "$libusb_path" "$pkg_libusb"
fi

# Perform the build
# ====================
bash "bootstrap.sh"
./configure --prefix="$pkgroot$install_prefix"

make
make install

popd
