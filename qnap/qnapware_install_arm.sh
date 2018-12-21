#!/bin/sh

. /etc/init.d/functions
FindDefVol
mkdir ${DEF_VOLMP}/@Qnapware

echo "Info: Checking for prerequisites and creating folders..."
if [ -d /Apps ]
then
    echo "Warning: Folder /Apps exists!"
    exit 1
else
    mkdir /Apps
    mount -o bind ${DEF_VOLMP}/@Qnapware /Apps
fi
if [ -d /Apps/opt ]
then
    echo "Warning: Folder /Apps/opt exists!"
else
    mkdir /Apps/opt
fi
for folder in bin etc include lib sbin share tmp usr var
do
  if [ -d "/Apps/opt/$folder" ]
  then
    echo "Warning: Folder /Apps/opt/$folder exists!"
    echo "Warning: If something goes wrong please clean /opt folder and try again."
  else
    mkdir /Apps/opt/$folder
  fi
done
[ -d "/Apps/opt/lib/opkg" ] || mkdir -p /Apps/opt/lib/opkg
[ -d "/Apps/opt/var/lock" ] || mkdir -p /Apps/opt/var/lock
[ -d "/Apps/opt/var/log" ] || mkdir -p /Apps/opt/var/log
[ -d "/Apps/opt/var/run" ] || mkdir -p /Apps/opt/var/run

echo "Info: Opkg package manager deployment..."
cd /Apps/opt/bin
wget http://qnapware.zyxmon.org/binaries-arm/installer/opkg
chmod +x /Apps/opt/bin/opkg
cd /Apps/opt/etc
wget http://qnapware.zyxmon.org/binaries-arm/installer/opkg.conf
cd /Apps/opt/lib
wget http://qnapware.zyxmon.org/binaries-arm/installer/ld-2.20.so
chmod +x ld-2.20.so
ln -s ld-2.20.so ld-linux.so.3
wget http://qnapware.zyxmon.org/binaries-arm/installer/libc-2.20.so
ln -s libc-2.20.so libc.so.6

echo "Info: Basic packages installation..."
/Apps/opt/bin/opkg update
/Apps/opt/bin/opkg install qnapware

echo "Info: Congratulations!"
echo "Info: If there are no errors above then Entware successfully initialized."
echo "Info: Add /Apps/opt/bin & /Apps/opt/sbin to your PATH variable"
echo "Info: Add '/Apps/opt/etc/init.d/rc.unslung start' to startup script for qnapware services to start"
echo "Info: Found a Bug? Please report at https://github.com/Entware/entware/issues"
