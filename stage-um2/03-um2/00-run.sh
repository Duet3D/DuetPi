#!/bin/bash
#install -m 644 files/config.g -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/config.g"

# Install preset files for UMDuet2
cp -rp files/macros/* "${ROOTFS_DIR}/boot/macros/"
cp -rp files/macros/* "${ROOTFS_DIR}/opt/dsf/sd/macros/"
#install -md 644 files/macros/* -o 996 -g 996 "${ROOTFS_DIR}/boot/macros/"
#install -md 644 files/macros/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/macros/"
#install -m 755 files/sys/* -o 996 -g 996 "${ROOTFS_DIR}/boot/sys/"
#install -m 755 files/sys/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/"
#install -d 755 files/sys/ExecOnMcode/* -o 996 -g 996 "${ROOTFS_DIR}/boot/sys/ExecOnMcode/"
#install -d 755 files/sys/ExecOnMcode/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/ExecOnMcode/"
cp -rp files/sys/* "${ROOTFS_DIR}/boot/sys/"
cp -rp files/sys/* "${ROOTFS_DIR}/opt/dsf/sd/sys/"
#install -md 644 files/filaments/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/filaments/"
#install -md 644 files/filaments/* -o 996 -g 996 "${ROOTFS_DIR}/boot/filaments/"
cp -rp files/filaments/* "${ROOTFS_DIR}/boot/filaments/"
cp -rp files/filaments/* "${ROOTFS_DIR}/opt/dsf/sd/filaments/"
#cp -rp files/gcodes/* "${ROOTFS_DIR}/boot/gcodes/"
#cp -rp files/gcodes/* "${ROOTFS_DIR}/opt/dsf/sd/gcodes/"
#cp -Rp files/plugins/* "${ROOTFS_DIR}/opt/dsf/plugins/"
cp -Rp files/TC_beta "${ROOTFS_DIR}/boot/"
 
install -m 644 files/wpa_supplicant.conf "${ROOTFS_DIR}/boot/"

install -m 644 files/720_1280_background.png "${ROOTFS_DIR}/usr/share/wallpapers/720_1280_background.png"

on_chroot << EOF
chown -R dsf:dsf /opt/dsf/sd/*
systemctl disable bluetooth 
systemctl enable ssh

update-alternatives --install /usr/share/desktop-base/720_1280_background.png desktop-background /usr/share/wallpapers/720_1280_background.png 80
update-alternatives --set desktop-background /usr/share/wallpapers/720_1280_background.png
EOF
