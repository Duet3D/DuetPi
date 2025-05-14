#!/bin/bash -e

# Create default RRF directories
mkdir "${ROOTFS_DIR}/boot/firmware/filaments"
mkdir "${ROOTFS_DIR}/boot/firmware/firmware"
mkdir "${ROOTFS_DIR}/boot/firmware/gcodes"
mkdir "${ROOTFS_DIR}/boot/firmware/macros"
mkdir "${ROOTFS_DIR}/boot/firmware/menu"
mkdir "${ROOTFS_DIR}/boot/firmware/sys"
mkdir "${ROOTFS_DIR}/boot/firmware/www"

# Install default config.g
install files/config.g "${ROOTFS_DIR}/boot/firmware/sys/config.g"

# Install one-time service to overwrite config.g if it diverges from the shipped default
CONFIG_G_SHA256SUM=$(sha256sum files/config.g | cut -d ' ' -f 1)
install -m 755 files/replace-dsf-configs "${ROOTFS_DIR}/usr/bin/replace-dsf-configs"
sed -i "s/CONFIG_G_SHA256SUM/$CONFIG_G_SHA256SUM/g" "${ROOTFS_DIR}/usr/bin/replace-dsf-configs"

install -m 644 files/replace-dsf-configs.service "${ROOTFS_DIR}/usr/lib/systemd/system/replace-dsf-configs.service"

# Obtain and install the latest RepRapFirmware files for Duet 3
RRF_ASSETS_URL=`curl "https://api.github.com/repos/Duet3D/RepRapFirmware/releases" | jq 'map(select( .prerelease == false )) | .[0].assets_url' -r`
RRF_PKG_URL=`curl "$RRF_ASSETS_URL" | jq '.[] | select(.browser_download_url | test("Duet2and3Firmware.*\\\\.zip$")) | .browser_download_url' -r`
curl -L "$RRF_PKG_URL" | bsdtar -xf - --include "Duet3*" --include "DuetWiFiServer.bin" -C "${ROOTFS_DIR}/boot/firmware/firmware"

# Obtain and install the latest DWC SD package
DWC_ASSETS_URL=`curl "https://api.github.com/repos/Duet3D/DuetWebControl/releases" | jq 'map(select( .prerelease == false )) | .[0].assets_url' -r`
DWC_SD_PKG_URL=`curl "$DWC_ASSETS_URL" | jq '.[] | select(.browser_download_url | test("SD\\\\.zip$")) | .browser_download_url' -r`
curl -L "$DWC_SD_PKG_URL" | bsdtar -xf - -C "${ROOTFS_DIR}/boot/firmware/www"

# Enable one-time service
on_chroot << EOF
systemctl daemon-reload
systemctl enable replace-dsf-configs
EOF

