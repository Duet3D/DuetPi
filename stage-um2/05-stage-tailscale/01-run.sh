#!/bin/bash -e

# Copio i file nella rootfs target
install -Dm 644 files/firstboot-tailscale.service "${ROOTFS_DIR}/etc/systemd/system/firstboot-tailscale.service"
install -Dm 755 files/firstboot-tailscale.sh "${ROOTFS_DIR}/usr/local/sbin/firstboot-tailscale.sh"
install -Dm 755 files/firstboot-tailscale-interactive.sh "${ROOTFS_DIR}/etc/profile.d/firstboot-tailscale-interactive.sh"
install -Dm 644 files/TC.conf "${ROOTFS_DIR}/boot/TC.conf"
