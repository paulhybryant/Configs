#!/bin/sh

. /etc/init.d/functions
QNAPWARE_DIR=${1:-"${DEF_VOLMP}/@Qnapware"}

echo "Info: Checking for prerequisites and creating folders..."
if [ -d ${QNAPWARE_DIR} ]
then
    echo "Warning: Folder ${QNAPWARE_DIR} exists!"
else
    mkdir ${QNAPWARE_DIR}
fi
if [ -d ${QNAPWARE_DIR}/opt ]
then
    echo "Warning: Folder ${QNAPWARE_DIR}/opt exists!"
else
    mkdir ${QNAPWARE_DIR}/opt
fi
for folder in bin etc include lib sbin share tmp usr var
do
  if [ -d "${QNAPWARE_DIR}/opt/$folder" ]
  then
    echo "Warning: Folder ${QNAPWARE_DIR}/opt/$folder exists!"
    echo "Warning: If something goes wrong please clean ${QNAPWARE_DIR}/opt folder and try again."
  else
    mkdir ${QNAPWARE_DIR}/opt/$folder
  fi
done
[ -d "${QNAPWARE_DIR}/opt/lib/opkg" ] || mkdir -p ${QNAPWARE_DIR}/opt/lib/opkg
[ -d "${QNAPWARE_DIR}/opt/var/lock" ] || mkdir -p ${QNAPWARE_DIR}/opt/var/lock
[ -d "${QNAPWARE_DIR}/opt/var/log" ] || mkdir -p ${QNAPWARE_DIR}/opt/var/log
[ -d "${QNAPWARE_DIR}/opt/var/run" ] || mkdir -p ${QNAPWARE_DIR}/opt/var/run

echo "Info: Opkg package manager deployment..."
cd ${QNAPWARE_DIR}/opt/bin
wget http://qnapware.zyxmon.org/binaries-arm/installer/opkg
chmod +x ${QNAPWARE_DIR}/opt/bin/opkg
cd ${QNAPWARE_DIR}/opt/etc
wget http://qnapware.zyxmon.org/binaries-arm/installer/opkg.conf
cd ${QNAPWARE_DIR}/opt/lib
wget http://qnapware.zyxmon.org/binaries-arm/installer/ld-2.20.so
chmod +x ld-2.20.so
ln -s ld-2.20.so ld-linux.so.3
wget http://qnapware.zyxmon.org/binaries-arm/installer/libc-2.20.so
ln -s libc-2.20.so libc.so.6

echo "Info: Basic packages installation..."
${QNAPWARE_DIR}/opt/bin/opkg update
${QNAPWARE_DIR}/opt/bin/opkg install qnapware

echo "Info: Congratulations!"
echo "Info: If there are no errors above then Entware successfully initialized."
echo "Info: Add ${QNAPWARE_DIR}/opt/bin & ${QNAPWARE_DIR}/opt/sbin to your PATH variable"
echo "Info: Add '${QNAPWARE_DIR}/opt/etc/init.d/rc.unslung start' to startup script for qnapware services to start"
echo "Info: Found a Bug? Please report at https://github.com/Entware/entware/issues"
