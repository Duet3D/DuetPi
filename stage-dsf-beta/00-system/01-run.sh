#!/bin/bash

install -m644 files/spidev.conf "${ROOTFS_DIR}/etc/modprobe.d/spidev.conf"
install -m644 files/minirc.dfl "${ROOTFS_DIR}/etc/minicom/minirc.dfl"
install files/wpa_supplicant.conf "${ROOTFS_DIR}/boot/wpa_supplicant.conf"

# Install override file for usbmount
install -m 755 -d "${ROOTFS_DIR}/etc/systemd/system/systemd-udevd.service.d"
install -m 644 files/privateMounts.conf "${ROOTFS_DIR}/etc/systemd/system/systemd-udevd.service.d/privateMounts.conf"

on_chroot << EOF
chown pi:root /etc/hostname
chown pi:root /etc/hosts

systemctl disable rsyslog
systemctl disable dnsmasq
systemctl disable hostapd
systemctl disable inetd
systemctl disable proftpd

apt-get purge -y rsyslog
EOF
