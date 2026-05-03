#!/bin/bash -e

install -Dm 755 files/firstboot-tailscale.sh \
    "${ROOTFS_DIR}/usr/local/sbin/firstboot-tailscale.sh"

install -Dm 644 files/firstboot-tailscale.service \
    "${ROOTFS_DIR}/etc/systemd/system/firstboot-tailscale.service"

install -Dm 644 files/TC.conf \
    "${ROOTFS_DIR}/boot/firmware/TC.conf"

on_chroot << EOF
systemctl enable tailscaled
systemctl enable firstboot-tailscale
EOF
