# AVR Toolchain Build Scripts
- Reference: [nognu.org](https://www.nongnu.org/avr-libc/user-manual/install_tools.html)
- License: BSD 3-Clause "New" or "Revised" license 

## Development Status

Wow, this is a mess!  I have created this repository just to share the work I have done with anyone who might benefit
from it.  If you happen to be one of those people, pull requests are encouraged, but not required. 

Please be aware that this is currently broken, but a decent amount of work has been done.  I have refactored a bit since
this was usable, but have not updated relative paths in the files.  Also, I originally went to each project site and
downloaded a source tarball, so these scripts expect source tarballs.  I don't want to include those in this repository
for licensing reasons.  I believe the only the DFU-Programmer and GCC scripts (now in components/<...>) will attempt to
get the latest version from their respective official source control repos if no version is specified.

For what it is worth, I was able to successfully build and install all of the included components (on OS X) using the
build scripts in this repository (before refactoring).

## Included Build Scripts

- avr-libc
- avrdude
- binutils
- dfu-programmer
- gcc

## Running

**tl;dr**: it won't run without some work.

Ideally there will be a Makefile that has targets to replace the scripts in the root directory of this project.

Regarding the scripts in the root directory, ideally `/build-package.sh` would build all the components, a currently
non-existent `/install.sh` would install the built components, and `/clean.sh` would remove all built files.

To actually get this to do anything other than break, the issues mentioned in the first section of this file will need
to be resolved.


## Project Goals

The original goal of this project was to allow anyone to easily use a "real" compiler to write
code for an Arduino Uno.

