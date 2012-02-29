#!/sbin/sh
export PATH=/vendor/bin:/system/sbin:/system/bin:/system/xbin:/sbin;
KP=$1;
echo $KP;
case ${KP} in
2)
#time /sbin/e2fsck -p /dev/block/mmcblk0p2
#time /sbin/e2fsck -p /dev/block/mmcblk0p3
#time sbin/e2fsck -p /dev/block/stl8
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/mmcblk0p2 /system
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/mmcblk0p3 /data
mount -t rfs -o rw,check=no /dev/block/stl8 /cache
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl8 /cache
cp /sbin/recovery2.fstab /misc/recovery.fstab
;;
*)
#time /sbin/e2fsck -p /dev/block/stl6
#time /sbin/e2fsck -p /dev/block/stl8
#time /sbin/e2fsck -p /dev/block/stl7
mount -t rfs -o rw,check=no /dev/block/stl6 /system
mount -t ext4 -o noatime,data=writeback,noauto_da_alloc,barrier=0,commit=20 /dev/block/stl6 /system
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl6 /system
mount -t rfs -o rw,check=no /dev/block/stl7 /data
mount -t ext4 -o noatime,data=writeback,noauto_da_alloc,barrier=0,commit=20 /dev/block/stl7 /data
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl7 /data
mount -t rfs -o rw,check=no /dev/block/stl8 /cache
mount -t ext2 -o rw,noatime,nodiratime,errors=continue /dev/block/stl8 /cache
cp /sbin/recovery1.fstab /misc/recovery.fstab
;;
esac

echo case

/sbin/killall system_server
/sbin/killall servicemanager
/sbin/killall mediaserver
/sbin/killall surfaceflinger
/sbin/killall zygote
/sbin/killall keystore
/sbin/killall drmserver
/sbin/killall dbus-daemon
/sbin/killall netd
/sbin/killall vold
/sbin/killall debuggerd
/sbin/killall rild

echo kill

if [ $bootmode = "2" ]
then
umount /system
umount /data
ln -s /initnani234 /sbin/ueventd
exec /initnani234
else
version=`grep -i ro.build.version.release /system/build.prop|awk '{FS="="};{print $2}'`
case $version in
4*)
cp /sbin/init401.rc /init.rc
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
