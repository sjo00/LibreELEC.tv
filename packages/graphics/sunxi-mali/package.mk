################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="sunxi-mali"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/linux-sunxi/sunxi-mali"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_SHORTDESC="Sunxi Mali userspace driver"
PKG_LONGDESC="Sunxi Mali userspace driver"
PKG_TOOLCHAIN="manual"

case $DEVICE in
  H6)
    PKG_VERSION="ac4f95e6860f71dac5a01bf1195c5e3a073df2d2"
    PKG_URL="https://github.com/jernejsk/H6-mali-userspace/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_DIR="H6-mali-userspace-$PKG_VERSION"
    PKG_DEPENDS_TARGET="toolchain minigbm"
    INCLUDE_DIR=include
    LIBNAME=libmali.so
    if [ "$ARCH" = "arm" ]; then
      MALI="lib/$LIBNAME"
    else
      MALI="lib64/$LIBNAME"
    fi
    ;;
  *)
    PKG_VERSION="3d7f4d4"
    PKG_URL="https://github.com/mosajjal/r6p2/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_DIR="r6p2-$PKG_VERSION*"
    PKG_SHA256="ef5f0f2c0545d1a20d283b87aa447f452e353150cdffadc7f405559e42626cb8"
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libdrm wayland"
    INCLUDE_DIR=fbdev/include
    LIBNAME=libMali.so
    MALI="libwayland_for_mali/h3/lib_wayland/$LIBNAME"
    ;;
esac

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include/
    cp -av $INCLUDE_DIR/* $SYSROOT_PREFIX/usr/include

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -PRv $PKG_DIR/pkgconfig/*.pc $SYSROOT_PREFIX/usr/lib/pkgconfig

  mkdir -p $SYSROOT_PREFIX/usr/lib/
    cp -v $MALI $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/lib
    cp -v $MALI $INSTALL/usr/lib

    for lib in libEGL.so \
               libEGL.so.1 \
               libEGL.so.1.4 \
               libGLESv2.so \
               libGLESv2.so.2 \
               libGLESv2.so.2.0; do
      ln -sfv $LIBNAME $INSTALL/usr/lib/${lib}
      ln -sfv $LIBNAME $SYSROOT_PREFIX/usr/lib/${lib}
    done

    if [ "$DEVICE" != "H6" ]; then
      for lib in libgbm.so \
                 libgbm.so.1; do
        ln -sfv $LIBNAME $INSTALL/usr/lib/${lib}
        ln -sfv $LIBNAME $SYSROOT_PREFIX/usr/lib/${lib}
      done
    fi
}
