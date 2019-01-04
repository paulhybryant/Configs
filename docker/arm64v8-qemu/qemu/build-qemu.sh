#!/bin/bash
#
# IMPORTANT!
# At the moment this script is forged only for Debian ( tested on 8.x release ).
#
# Run this script inside a debian container using: docker run -it debian bash
#
# Although my efforts were put on building this also on Arch Linux or Alpine, at the moment only Debian seems to be able to build it.
# Also, not sure why these instructions where nowhere on the internet, therefore I leave them here for whoever need them.
#
###########

# Add Backports repo support
echo -e "deb http://ftp.debian.org/debian jessie-backports main\ndeb-src http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

# Install all required development packages
apt-get update && apt-get build-dep qemu

export GIT_SSL_NO_VERIFY=true
apt-get install git

# Clone a fork of QEMU that supports permanent EXECVE ( see https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/ )
git clone https://github.com/resin-io/qemu.git
#git clone https://github.com/julianxhokaxhiu/qemu.git
cd qemu
#git checkout execve-2.9
git checkout resin-2.9.0

# Build the binaries in a static old fashion way
mkdir build
cd build
../configure --disable-bsd-user --disable-guest-agent --disable-strip --disable-werror --disable-gcrypt --disable-debug-info --disable-debug-tcg --enable-docs --disable-tcg-interpreter --enable-attr --disable-brlapi --disable-linux-aio --disable-bzip2 --disable-bluez --disable-cap-ng --disable-curl --disable-fdt --disable-glusterfs --disable-gnutls --disable-nettle --disable-gtk --disable-rdma --disable-libiscsi --disable-vnc-jpeg --disable-kvm --disable-lzo --disable-curses --disable-libnfs --disable-numa --disable-opengl --disable-vnc-png --disable-rbd --disable-vnc-sasl --disable-sdl --disable-seccomp --disable-smartcard --disable-snappy --disable-spice --disable-libssh2 --disable-libusb --disable-usb-redir --disable-vde --disable-vhost-net --disable-virglrenderer --disable-virtfs --disable-vnc --disable-vte --disable-xen --disable-xen-pci-passthrough --disable-xfsctl --enable-linux-user --disable-system --disable-blobs --disable-tools --target-list=aarch64-linux-user --static --disable-pie
make
