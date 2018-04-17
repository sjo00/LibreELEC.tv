################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
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

PKG_NAME="gpu-sunxi"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="gpu-sunxi: Linux drivers for Mali GPUs found in Allwinner SoCs"
PKG_LONGDESC="gpu-sunxi: Linux drivers for Mali GPUs found in Allwinner SoCs"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

case "$DEVICE" in
  H6)
    PKG_VERSION="r22p0-01rel0"
    PKG_SHA256="02f80e777dc945d645fce888afc926555ec61b70079c1da289bf1a3a9544452f"
    PKG_URL="https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-midgard-gpu/TX011-SW-99002-$PKG_VERSION.tgz"
    PKG_SOURCE_DIR="TX011-SW-99002-$PKG_VERSION"
    DRIVER_DIR=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard/
    ;;
  *)
    PKG_VERSION="r6p2-01rel0"
    PKG_SHA256="bb49d23ab3d9fbeb701a127e6f28cff1c963bba05786f98d76edff1df0fe6c52"
    PKG_URL="https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu/DX910-SW-99002-$PKG_VERSION.tgz"
    PKG_SOURCE_DIR="DX910-SW-99002-$PKG_VERSION"
    DRIVER_DIR=$PKG_BUILD/src/devicedrv/mali/
    ;;
esac

pre_patch() {
  if [ "$DEVICE" != "H6" ] ; then
    # move source dir to allow patching
    mv $PKG_BUILD/driver/src $PKG_BUILD/
    rm -rf $PKG_BUILD/driver
  fi
}

make_target() {
  if [ "$DEVICE" = "H6" ] ; then
    LDFLAGS="" make -C $(kernel_path) M=$DRIVER_DIR \
    EXTRA_CFLAGS="-DCONFIG_MALI_PLATFORM_DEVICETREE -DCONFIG_MALI_BACKEND=gpu -DCONFIG_MALI_DEVFREQ" CONFIG_MALI_DEVFREQ=y \
      CONFIG_MALI_MIDGARD=m CONFIG_MALI_PLATFORM_DEVICETREE=y CONFIG_MALI_BACKEND=gpu modules
  else
    USING_UMP=0 \
    BUILD=$BUILD \
    USING_PROFILING=0 \
    MALI_PLATFORM=sunxi \
    USING_DVFS=1 \
    USING_DEVFREQ=0 \
    KDIR=$(kernel_path) \
    CROSS_COMPILE=$TARGET_PREFIX \
    make -C $DRIVER_DIR
  fi
}

makeinstall_target() {
  LDFLAGS="" make -C $(kernel_path) M=$DRIVER_DIR \
    INSTALL_MOD_PATH=$INSTALL/$(get_kernel_overlay_dir) INSTALL_MOD_STRIP=1 DEPMOD=: \
    modules_install
}
