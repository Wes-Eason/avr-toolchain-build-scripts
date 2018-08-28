export pkgroot="$PWD/pkgroot"

export PATH="$PATH:$PWD/$pkgroot/usr/local/bin"
export LD_LIBRARY_PATH=$pkgroot/usr/local/lib
export C_INCLUDE_PATH=$pkgroot/usr/local/include
export CPLUS_INCLUDE_PATH=$pkgroot/usr/local/include

export source_archive_dir="source_archives"
#export source_extract_dir="source_extracted"
export logfile="build.log"
export install_prefix="usr/local"
