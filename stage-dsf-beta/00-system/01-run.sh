#!/bin/bash

install -m644 files/spidev.conf "${ROOTFS_DIR}/etc/modprobe.d/spidev.conf"
install -m644 files/minirc.dfl "${ROOTFS_DIR}/etc/minicom/minirc.dfl"

on_chroot << EOF
systemctl disable dnsmasq
systemctl disable hostapd
systemctl disable inetd
systemctl disable proftpd
EOF
