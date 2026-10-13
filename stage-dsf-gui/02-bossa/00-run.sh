#!/bin/bash -e

# 07-bossa of stage-dsf covers bossac and bossash, the GUI is kept out of the lite image
BOSSA_TAG=`curl "https://api.github.com/repos/Duet3D/BOSSA/releases" | jq 'map(select( .prerelease == false )) | .[0].tag_name' -r`
mkdir -p "${ROOTFS_DIR}/usr/src/bossa"
curl -L "https://github.com/Duet3D/BOSSA/archive/refs/tags/${BOSSA_TAG}.tar.gz" | bsdtar -xf - --strip-components 1 -C "${ROOTFS_DIR}/usr/src/bossa"
