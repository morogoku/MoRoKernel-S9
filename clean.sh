#!/bin/bash
#
# MoRoKernel Cleaning Script 1.0
#

# Clean Build Data
make clean
make ARCH=arm64 distclean

rm -f ./*.log


# Remove Release files
rm -f $PWD/build/*.zip
rm -rf $PWD/build/temp
rm -f $PWD/arch/arm64/configs/tmp_defconfig
rm -f $PWD/build/zip/*.img
rm -rf $PWD/net/wireguard
rm -rf $PWD/scripts/fmp/__pycache__
rm -rf $PWD/scripts/crypto/__pycache__

cp -f $PWD/build/ologk.h $PWD/include/linux


# Removed Created dtb Folder
rm -rf $PWD/arch/arm64/boot/dtb
rm -f $PWD/arch/arm64/boot/dts/exynos/*.reverse.dts


# Recreate Ramdisk Placeholders
echo "" > build/ramdisk/ramdisk/apex/.placeholder
echo "" > build/ramdisk/ramdisk/debug_ramdisk/.placeholder
echo "" > build/ramdisk/ramdisk/dev/.placeholder
echo "" > build/ramdisk/ramdisk/mnt/.placeholder
echo "" > build/ramdisk/ramdisk/proc/.placeholder
echo "" > build/ramdisk/ramdisk/sys/.placeholder




