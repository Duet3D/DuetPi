#!/bin/bash -e

# Create default RRF directories
mkdir "${ROOTFS_DIR}/boot/filaments"
mkdir "${ROOTFS_DIR}/boot/gcodes"
mkdir "${ROOTFS_DIR}/boot/macros"
mkdir "${ROOTFS_DIR}/boot/sys"
mkdir "${ROOTFS_DIR}/boot/www"

# Install config.g
install files/config.g "${ROOTFS_DIR}/boot/sys/config.g"

# Obtain and install the latest DWC SD package
DWC_ASSETS_URL=`curl "https://api.github.com/repos/chrishamm/DuetWebControl/releases" | jq '.[0].assets_url' -r`
DWC_SD_PKG_URL=`curl "$DWC_ASSETS_URL" | jq '.[] | select(.browser_download_url | test("SD\\\\.zip$")) | .browser_download_url' -r`
curl -L "$DWC_SD_PKG_URL" | bsdtar -xf - -C "${ROOTFS_DIR}/boot/www"

