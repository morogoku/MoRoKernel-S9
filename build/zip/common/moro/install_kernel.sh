#!/sbin/sh
#
# MoRoKernel Flash script 2.0
#
# Credit also goes to @djb77
# @lyapota, @Tkkg1994, @osm0sis
# @dwander for bits of code
# 

# Functions
ui_print() { echo -n -e "ui_print $1\n"; }

file_getprop() { grep "^$2" "$1" | cut -d= -f2; }

show_progress() { echo "progress $1 $2"; }

set_progress() { echo "set_progress $1"; }

set_perm() {
  chown $1.$2 $4
  chown $1:$2 $4
  chmod $3 $4
  chcon $5 $4
}

clean_magisk() {
	rm -rf /cache/*magisk* /cache/unblock /data/*magisk* /data/cache/*magisk* /data/property/*magisk* \
        /data/Magisk.apk /data/busybox /data/custom_ramdisk_patch.sh /data/app/com.topjohnwu.magisk* \
        /data/user*/*/magisk.db /data/user*/*/com.topjohnwu.magisk /data/user*/*/.tmp.magisk.config \
        /data/adb/*magisk* 2>/dev/null
}

abort() {
	ui_print "$*";
	exit 1;
}

# Initialice Morokernel folder
mkdir -p -m 777 /data/.morokernel/apk 2>/dev/null


# Variables
BB=/sbin/busybox
SDK="$(file_getprop /system/build.prop ro.build.version.sdk)"
BL=`getprop ro.bootloader`
MODEL=${BL:0:4}
MODEL1=G960
MODEL1_DESC="S9 G960"
MODEL2=G965
MODEL2_DESC="S9 Plus G965"
if [ $MODEL == $MODEL1 ]; then MODEL_DESC=$MODEL1_DESC; fi
if [ $MODEL == $MODEL2 ]; then MODEL_DESC=$MODEL2_DESC; fi	


#======================================
# AROMA INIT
#======================================

set_progress 0.01

## CHECK SUPPORT, MODEL AND OS
if [ $MODEL == $MODEL1 ] || [ $MODEL == $MODEL2 ]; then
	ui_print " "
	ui_print "@Device detected"
	# Set OS
	ui_print "-- $MODEL_DESC"
else
	ui_print " "
	ui_print "@** UNSUPPROTED DEVICE! **"
	abort "-- The kernel is only for $VAR1 and $VAR2, and this device is $MODEL. Aborting..."
fi


set_progress 0.10
show_progress 0.25 -4000

## FLASH KERNEL
ui_print " "
ui_print "@Flashing kernel"

cd /tmp/moro
ui_print "-- Extracting"
$BB tar -Jxf kernel.tar.xz $MODEL-boot.img
ui_print "-- Flashing kernel $MODEL-boot.img"
dd of=/dev/block/platform/11120000.ufs/by-name/BOOT if=/tmp/moro/$MODEL-boot.img
ui_print "-- Done"


set_progress 0.35


## PATCH SYSTEM
ui_print " "
ui_print "@Patching system and vendor libs"
cp -rf system/. /system
rm -rf /system/priv-app/Rlc
rm -rf /system/app/SecurityLogAgent


set_progress 0.40

#======================================
# OPTIONS
#======================================


## MTWEAKS
if [ "$(file_getprop /tmp/aroma/menu.prop chk2)" == 1 ]; then
	ui_print " "
	ui_print "@MTWeaks App"
	sh /tmp/moro/moro_clean.sh com.moro.mtweaks -as
	cp -rf /tmp/moro/mtweaks/. /data/.morokernel/apk
fi


set_progress 0.45
show_progress 0.25 -5000

## PERMISSIONS
ui_print " "
ui_print "@Setting Permissions"
set_perm 0 2000 0644 /system/lib/libsecure_storage.so u:object_r:system_file:s0
set_perm 0 2000 0644 /system/lib/libsecure_storage_jni.so u:object_r:system_file:s0
set_perm 0 2000 0644 /system/lib64/libsecure_storage.so u:object_r:system_file:s0
set_perm 0 2000 0644 /system/lib64/libsecure_storage_jni.so u:object_r:system_file:s0


set_progress 0.65

#======================================
# ROOT
#======================================


ui_print " "
ui_print "@Root"
	
## WITHOUT ROOT
if [ "$(file_getprop /tmp/aroma/menu.prop group1)" == "opt1" ]; then
	ui_print "-- Without Root"
	if [ "$(file_getprop /tmp/aroma/menu.prop chk7)" == 1 ]; then
		ui_print "-- Clear root data"
		clean_magisk
		sh /tmp/moro/moro_clean.sh com.topjohnwu.magisk -asd
	fi
fi


## MAGISK ROOT
if [ "$(file_getprop /tmp/aroma/menu.prop group1)" == "opt2" ]; then
show_progress 0.34 -19000

	if [ "$(file_getprop /tmp/aroma/menu.prop chk7)" == 1 ]; then
		ui_print "-- Clearing root data"
		clean_magisk
		sh /tmp/moro/moro_clean.sh com.topjohnwu.magisk -asd
	fi

	# Install apk
	cp -rf /tmp/moro/magisk/magisk.apk /data/.morokernel/apk

	ui_print "-- Rooting with Magisk Manager"
	ui_print " "
	$BB unzip /tmp/moro/magisk/magisk.zip META-INF/com/google/android/* -d /tmp/moro/magisk
	sh /tmp/moro/magisk/META-INF/com/google/android/update-binary dummy 1 /tmp/moro/magisk/magisk.zip
fi


set_progress 1.00


