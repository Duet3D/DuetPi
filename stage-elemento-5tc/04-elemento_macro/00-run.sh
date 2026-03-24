#!/bin/bash
#install -m 644 files/config.g -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/config.g"

# Install preset files for UMDuet2
cp -rp files/macros/* "${ROOTFS_DIR}/boot/firmware/macros/"
cp -rp files/macros/* "${ROOTFS_DIR}/opt/dsf/sd/macros/"

on_chroot << EOF
chown -R dsf:dsf /opt/dsf/sd/*
EOF
