################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
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

PKG_NAME="sunxi-atf"
PKG_VERSION="c591d63bf4121ac1c3b452349d06d31625cc02ac"
PKG_SHA256="f0fdb3631c39d96f935a3ab044a03bd0d35a2d9c4380d8b31ff67c02ae17d784"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/Icenowy/arm-trusted-firmware"
PKG_URL="https://github.com/Icenowy/arm-trusted-firmware/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="arm-trusted-firmware-$PKG_VERSION*"
PKG_SECTION="tools"
PKG_SHORTDESC="sunxi-atf: Allwinner ARM Trusted Firmware"
PKG_LONGDESC="sunxi-atf: Allwinner ARM Trusted Firmware"
PKG_TOOLCHAIN="manual"

make_target() {
  CROSS_COMPILE="$TARGET_KERNEL_PREFIX" LDFLAGS="" CFLAGS="" make PLAT=sun50i_h6 DEBUG=1 bl31
}
