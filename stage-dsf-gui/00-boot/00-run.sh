#!/bin/bash

# Override default boot splash screen
install -d "${ROOTFS_DIR}/usr/share/plymouth/themes/duet3d"
install -m644 files/duet3d.plymouth "${ROOTFS_DIR}/usr/share/plymouth/themes/duet3d/duet3d.plymouth"
install -m644 files/duet3d.script "${ROOTFS_DIR}/usr/share/plymouth/themes/duet3d/duet3d.script"
install -m644 files/splash.png "${ROOTFS_DIR}/usr/share/plymouth/themes/duet3d/splash.png"

# Change default Plytmouth theme and turn off SSH in the GUI variant
on_chroot << EOF
plymouth-set-default-theme duet3d
systemctl disable ssh
EOF
