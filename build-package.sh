export pkgroot="$PWD/pkgroot"

export PATH="$PATH:$pkgroot/usr/local/bin"
export LD_LIBRARY_PATH=$pkgroot/usr/local/lib
export C_INCLUDE_PATH=$pkgroot/usr/local/include
export CPLUS_INCLUDE_PATH=$pkgroot/usr/local/include

export source_archive_dir="source_archives"
#export source_extract_dir="source_extracted"
export logfile="build.log"
export install_prefix=""

set -e

source util.sh

# make sure required files and dirs exist
mkdir -p "$source_archive_dir"
echo -n "" > "$logfile"


# Create package root
rm -rf "$pkgroot"
mkdir -p "$pkgroot$install_prefix/bin"


# Make symlinks to system headers
for item in $(ls /usr/local/include); do
    mkdir -p $pkgroot/usr/local/include
    ln -s /usr/local/include/$item $pkgroot/usr/local/include/$item
done


# Obtain and build package components
# ==========================================================
# Each of the scripts called below obtains and builds a component of this
# package.  Order is important.

declare -a components

components+=("binutils")
components+=("gcc")
components+=("avr-libc")
components+=("avrdude")
components+=("dfu-programmer")

i=0
while [ $i -lt ${#components[@]} ]; do
    component="${components[$i]}"

    bash "$component.sh" 2>&1 | log_prefix "$component"

    i=$(($i+1))
done




# Compile components into package
# ==========================================================

# Clean up package contents
find "$pkgroot" -type f -name ".DS_Store" -exec rm -f "{}" \;
find "$pkgroot" -type d -empty -exec rm -rf "{}" \;
find "$pkgroot" -type l | grep "^$pkgroot" | xargs rm


# Tar and gzip package
tar -C "$pkgroot" -c . | pigz > avr-tools.tar.gz
