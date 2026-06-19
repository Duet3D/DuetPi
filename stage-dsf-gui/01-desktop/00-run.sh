#!/bin/bash -e

install -m 644 files/duet3d.png "${ROOTFS_DIR}/usr/share/rpd-wallpaper/duet3d.png"
install -m 644 files/dwc.png "${ROOTFS_DIR}/usr/share/icons/dwc.png"
install -Dm 644 files/password-store "${ROOTFS_DIR}/etc/chromium.d/password-store"

# Override the packaged DWC launcher until these changes ship in duetwebcontrol
install -m 755 files/launch-dwc "${ROOTFS_DIR}/usr/bin/launch-dwc"

install -m 755 -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop"
install -dm 755 -o 1000 -g 1000 "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config"
install -dm 755 -o 1000 -g 1000 "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/labwc"
install -m 755 -o 1000 -g 1000 files/autostart "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/labwc/autostart"
install -m 644 -o 1000 -g 1000 files/wayfire.ini "${ROOTFS_DIR}/home/$FIRST_USER_NAME/.config/wayfire.ini"
install -m 755 -o 1000 -g 1000 files/launch-dwc.desktop "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop/launch-dwc.desktop"
install -m 755 -o 1000 -g 1000 files/view-dcs-log.desktop "${ROOTFS_DIR}/home/$FIRST_USER_NAME/Desktop/view-dcs-log.desktop"

# Disable touch mouse-emulation in the stock labwc config so Chromium receives
# native touch (a drag scrolls instead of selecting), and make the DWC window
# borderless and maximized. Anchored on the stock Kodi rule and closing tag;
# the greps fail the build if either anchor moves in a future release
rc_xml="${ROOTFS_DIR}/etc/xdg/labwc/rc.xml"
sed -i 's#\(<windowRule identifier="Kodi" serverDecoration="yes" />\)#\1\n    <windowRule identifier="chrom*" serverDecoration="no"><action name="Maximize" /></windowRule>#' "$rc_xml"
sed -i 's#</openbox_config>#  <touch mouseEmulation="no" />\n</openbox_config>#' "$rc_xml"
grep -q 'identifier="chrom\*"' "$rc_xml"
grep -q '<touch mouseEmulation="no"' "$rc_xml"

on_chroot << EOF
systemctl disable cups cups-browsed
apt-get purge -y system-config-printer
apt-get autoremove -y
EOF

