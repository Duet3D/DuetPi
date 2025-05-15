#!/bin/bash -e

install -m 644 files/duet3d.png "${ROOTFS_DIR}/usr/share/wallpapers/duet3d.png"
install -m 644 files/dwc.png "${ROOTFS_DIR}/usr/share/icons/dwc.png"

install -m 755 -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop"
install -dm 755 -o 1000 -g 1000 "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config"
install -dm 755 -o 1000 -g 1000 "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/labwc"
install -m 755 -o 1000 -g 1000 files/autostart "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/labwc/autostart"
install -m 644 -o 1000 -g 1000 files/wayfire.ini "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/wayfire.ini"
install -m 755 -o 1000 -g 1000 files/launch-dwc.desktop "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop/launch-dwc.desktop"
install -m 755 -o 1000 -g 1000 files/view-dcs-log.desktop "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop/view-dcs-log.desktop"
cp -Rp files/.config/* "${ROOTFS_DIR}/home/pi/.config/"

on_chroot << EOF
systemctl disable cups cups-browsed

update-alternatives --install /usr/share/desktop-base/duet3d.png desktop-background /usr/share/wallpapers/duet3d.png 80
update-alternatives --set desktop-background /usr/share/wallpapers/duet3d.png

raspi-config nonint do_camera 0
raspi-config nonint do_glamor 0
EOF
