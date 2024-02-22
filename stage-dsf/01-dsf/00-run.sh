#!/bin/bash -e

install -m 644 files/duet3d.gpg "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/duet3d.gpg"
install -m 644 files/duet3d.gpg "${ROOTFS_DIR}/usr/share/keyrings/duet3d.gpg"
install -m 644 files/duet3d.list "${ROOTFS_DIR}/etc/apt/sources.list.d/duet3d.list"

on_chroot << EOF
apt-get update
EOF
