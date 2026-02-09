#!/bin/bash

# Install udev rules and systemd service for USB auto-mounting
install -m644 files/99-usb-automount.rules "${ROOTFS_DIR}/etc/udev/rules.d/99-usb-automount.rules"
install -m644 files/usb-mount@.service "${ROOTFS_DIR}/etc/systemd/system/usb-mount@.service"

