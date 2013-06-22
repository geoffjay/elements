#!/bin/sh

# Run this to generate all the initial makefiles, etc.
# XXX Possibly consider going back to generic autogen as this likely won't need
#     Gnome support in the future.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="elements"

(test -f $srcdir/configure.ac \
  && test -f $srcdir/README.md \
  && test -d $srcdir/src) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common"
    exit 1
}
REQUIRED_AUTOMAKE_VERSION=1.7 USE_GNOME2_MACROS=1 . gnome-autogen.sh --enable-gtk-doc "$@"
