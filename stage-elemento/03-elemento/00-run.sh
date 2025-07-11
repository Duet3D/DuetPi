#!/bin/bash
#install -m 644 files/config.g -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/config.g"

# Install preset files for UMDuet2
cp -rp files/macros/* "${ROOTFS_DIR}/boot/firmware/macros/"
cp -rp files/macros/* "${ROOTFS_DIR}/opt/dsf/sd/macros/"
#install -md 644 files/macros/* -o 996 -g 996 "${ROOTFS_DIR}/boot/firmware/macros/"
#install -md 644 files/macros/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/macros/"
#install -m 755 files/sys/* -o 996 -g 996 "${ROOTFS_DIR}/boot/firmware/sys/"
#install -m 755 files/sys/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/"
#install -d 755 files/sys/ExecOnMcode/* -o 996 -g 996 "${ROOTFS_DIR}/boot/firmware/sys/ExecOnMcode/"
#install -d 755 files/sys/ExecOnMcode/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/ExecOnMcode/"
cp -rp files/sys/* "${ROOTFS_DIR}/boot/firmware/sys/"
cp -rp files/sys/* "${ROOTFS_DIR}/opt/dsf/sd/sys/"
#install -md 644 files/filaments/* -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/filaments/"
#install -md 644 files/filaments/* -o 996 -g 996 "${ROOTFS_DIR}/boot/firmware/filaments/"
cp -rp files/filaments/* "${ROOTFS_DIR}/boot/firmware/filaments/"
cp -rp files/filaments/* "${ROOTFS_DIR}/opt/dsf/sd/filaments/"
cp -rp files/gcodes/* "${ROOTFS_DIR}/boot/firmware/gcodes/"
cp -rp files/gcodes/* "${ROOTFS_DIR}/opt/dsf/sd/gcodes/"
#cp -Rp files/plugins/* "${ROOTFS_DIR}/opt/dsf/plugins/"
cp -p files/TC.conf "${ROOTFS_DIR}/boot/firmware/TC.conf"
cp -p files/TCb.conf "${ROOTFS_DIR}/boot/firmware/TCb.conf"
cp -p files/TC.conf "${ROOTFS_DIR}/opt/dsf/sd/sys/TC.conf"
cp -p files/TCb.conf "${ROOTFS_DIR}/opt/dsf/sd/sys/TCb.conf"

cp -p files/TCb.conf "${ROOTFS_DIR}/boot/firmware/macros/fabbrix_cura_5_10_1.zip"
cp -p files/TCb.conf "${ROOTFS_DIR}/opt/dsf/sd/macros/fabbrix_cura_5_10_1.zip"

install -m 644 -v files/wpa_supplicant.conf "${ROOTFS_DIR}/boot/firmware/"

install -m 644 -v files/720_1280_background.png "${ROOTFS_DIR}/usr/share/wallpapers/720_1280_background.png"

on_chroot << EOF
chown -R dsf:dsf /opt/dsf/sd/*
systemctl disable bluetooth 
systemctl enable ssh

update-alternatives --install /usr/share/desktop-base/720_1280_background.png desktop-background /usr/share/wallpapers/720_1280_background.png 80
update-alternatives --set desktop-background /usr/share/wallpapers/720_1280_background.png
EOF
