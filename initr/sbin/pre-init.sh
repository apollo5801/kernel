#!/sbin/busybox sh
# Copyright 2010 Renaud Allard. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#    1. Redistributions of source code must retain the above copyright notice, this list of
#       conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above copyright notice, this list
#       of conditions and the following disclaimer in the documentation and/or other materials
#       provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY Renaud Allard ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Renaud Allard OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Renaud Allard.
# setup the global environment
    export PATH=/vendor/bin:/system/sbin:/system/bin:/system/xbin:/sbin
    export LD_LIBRARY_PATH=/vendor/lib:/system/lib
    export ANDROID_BOOTLOGO=1
    export ANDROID_CACHE=/cache
    export ANDROID_ROOT=/system
    export ANDROID_ASSETS=/system/app
    export ANDROID_DATA=/data
    export DOWNLOAD_CACHE=/cache/download
    export EXTERNAL_STORAGE=/mnt/sdcard
    export ASEC_MOUNTPOINT=/mnt/asec
    export LOOP_MOUNTPOINT=/mnt/obb
    export SD_EXT_DIRECTORY=/sd-ext
    export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/core-junit.jar

busybox insmod -f /lib/modules/fsr.ko
busybox insmod -f /lib/modules/fsr_stl.ko
busybox insmod -f /lib/modules/rfs_glue.ko
busybox insmod -f /lib/modules/rfs_fat.ko
busybox insmod -f /lib/modules/tun.ko
mkdir /proc
mkdir /sys
mount -t proc proc /proc
mount -t sysfs sys /sys
mkdir /acct
mount -t cgroup -o cpuacct none /acct 
mkdir /acct/uid
mkdir /tmp
mount -t tmpfs tmpfs /tmp
mkdir /dev
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mknod /dev/urandom c 1 9
mkdir /dev/block
mknod /dev/block/mmcblk0 b 179 0
mknod /dev/block/mmcblk0p1 b 179 1
mknod /dev/block/mmcblk0p2 b 179 2
mknod /dev/block/mmcblk0p3 b 179 3
mknod /dev/block/mmcblk0p4 b 179 4
mknod /dev/block/stl1 b 138 1
mknod /dev/block/stl2 b 138 2
mknod /dev/block/stl3 b 138 3
mknod /dev/block/stl4 b 138 4
mknod /dev/block/stl5 b 138 5
mknod /dev/block/stl6 b 138 6
mknod /dev/block/stl7 b 138 7
mknod /dev/block/stl8 b 138 8
mknod /dev/block/stl9 b 138 9
mknod /dev/block/stl10 b 138 10
mknod /dev/block/stl11 b 138 11
mknod /dev/block/stl12 b 138 12
mknod /dev/block/bml0!c b 137 0
mknod /dev/block/bml1 b 137 1
mknod /dev/block/bml2 b 137 2
mknod /dev/block/bml3 b 137 3
mknod /dev/block/bml4 b 137 4
mknod /dev/block/bml5 b 137 5
mknod /dev/block/bml6 b 137 6
mknod /dev/block/bml7 b 137 7
mknod /dev/block/bml8 b 137 8
mknod /dev/block/bml9 b 137 9
mknod /dev/block/bml10 b 137 10
mknod /dev/block/bml11 b 137 11
mknod /dev/block/bml12 b 137 12
mknod /dev/block/ramzswap0 b 253 0
mkdir /cache
mkdir /data
mkdir /system
chmod 0777 /data
chmod 0777 /cache
chown system /data
chgrp system /data
chown system /cache
chgrp cache /cache
echo 1024 > /sys/devices/virtual/bdi/179:0/read_ahead_kb
for f in `ls -d /sys/devices/virtual/block/stl*`
do
echo 1024 > $f/queue/read_ahead_kb
echo 0 > $f/queue/rotational
done
for f in `ls -d /sys/devices/virtual/block/bml*`
do
echo 1024 > $f/queue/read_ahead_kb
echo 0 > $f/queue/rotational
done

#echo "500" > /proc/sys/vm/dirty_expire_centisecs
#echo "1000" > /proc/sys/vm/dirty_writeback_centisecs
echo /dev/block/mmcblk0p1 > /sys/devices/platform/s3c-usbgadget/gadget/lun0/file

#mount -t debugfs none /sys/kernel/debug
#echo NO_NORMALIZED_SLEEPER > /sys/kernel/debug/sched_features
#umount /sys/kernel/debug

#echo "1536,2048,6656,7168,7680,8192" > /sys/module/lowmemorykiller/parameters/minfree
#echo "0,1,2,7,14,15" > /sys/module/lowmemorykiller/parameters/adj

sleep 1
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

#busybox insmod /lib/modules/ramzswap.ko disksize_kb=40000
#swapon /dev/block/ramzswap0

KP=1
DF=1
while [ $KP -ne "115" -a $KP -ne "114" -a $KP -ne "102" ]
do
if [ `dmesg|grep "S3C-Keypad : Pressed"|wc -l` -eq 0 ]
then
KP=1
else
KP=`dmesg|grep "S3C-Keypad : Pressed"|tail -n 1|awk '{print $5}'|sed -e 's/,//g'`
fi
if [ $DF = 10 ]
then
KP=102
else
DF=`expr $DF + 1`
fi
sleep 1
done

case $KP in
115)
#time /sbin/e2fsck -p /dev/block/mmcblk0p2
#time /sbin/e2fsck -p /dev/block/mmcblk0p3
#time sbin/e2fsck -p /dev/block/stl8
mount -t ext4 -o rw /dev/block/mmcblk0p2 /system
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/mmcblk0p2 /system
mount -t ext4 -o rw /dev/block/mmcblk0p3 /data
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/mmcblk0p3 /data
mount -t rfs -o rw,check=no /dev/block/stl8 /cache
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl8 /cache
cp /sbin/recovery2.fstab /misc/recovery.fstab
;;
114)
#time /sbin/e2fsck -p /dev/block/mmcblk0p4
#time /sbin/e2fsck -p /dev/block/stl8
mount -t ext4 -o rw /dev/block/mmcblk0p4 /system
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/mmcblk0p4 /system
mkdir /system/romdata/
mount -o bind /system/romdata /data
mount -t rfs -o rw,check=no /dev/block/stl8 /cache
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl8 /cache
cp /sbin/recovery3.fstab /misc/recovery.fstab
;;
*)
time /sbin/e2fsck -p /dev/block/stl6
time /sbin/e2fsck -p /dev/block/stl8
time /sbin/e2fsck -p /dev/block/stl7
mount -t rfs -o rw,check=no /dev/block/stl6 /system
#mount -t ext4 -o rw /dev/block/stl6 /system
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl6 /system
mount -t rfs -o rw,check=no /dev/block/stl7 /data
#mount -t ext4 -o rw /dev/block/stl7 /data
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl7 /data
mount -t rfs -o rw,check=no /dev/block/stl8 /cache
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl8 /cache
cp /sbin/recovery1.fstab /misc/recovery.fstab
;;
esac

echo "ro.media.enc.jpeg.quality=100" > /data/local.prop
echo "dalvik.vm.heapsize=48m" >> /data/local.prop
echo "debug.sf.hw=1" >> /data/local.prop
echo "ro.telephony.call_ring.delay=0" >> /data/local.prop
echo "windowsmgr.max_events_per_sec=150" >> /data/local.prop
echo "debug.performance.tuning=1" >> /data/local.prop
echo "video.accelerate.hw=1" >> /data/local.prop
echo "ro.media.dec.jpeg.memcap=8000000" >> /data/local.prop
echo "ro.media.enc.hprof.vid.bps=8000000" >> /data/local.prop
echo "ro.HOME_APP_ADJ=1" >> /data/local.prop
echo "ro.HOME_APP_MEM=8000" >> /data/local.prop
echo " " >> /data/local.prop

if [ $bootmode = "2" ]
then
ln -s /initnani234 /sbin/ueventd
exec /initnani234
else
version=`grep -i ro.build.version.release /system/build.prop|awk '{FS="="};{print $2}'`
if [ -f /system/lib/egl/libGLES_fimg.so ]
then
/sbin/busybox insmod /lib/modules/openfimg.ko
else
/sbin/busybox insmod /lib/modules/samsfimg.ko
fi
case $version in
4*)
cp /sbin/init401.rc /init.rc
cp /system/init401.rc /init.rc
cp /system/default.prop /default.prop
ln -s /initnani4 /sbin/ueventd
exec /initnani4
;;
2.3.*)
ln -s /initnani234 /sbin/ueventd
exec /initnani234
;;
2.2.1)
cp /sbin/init221.rc /init.rc
exec /initnani22
;;
2.2)
cp /sbin/init22.rc /init.rc
exec /initnani22
;;
*)
cp /sbin/init22.rc /init.rc
exec /initnani22
;;
esac
fi
