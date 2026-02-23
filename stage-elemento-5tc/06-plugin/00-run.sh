#!/bin/bash
# pi-gen stage script — place this in your custom stage directory, e.g.:
#   stage-custom/
#   └── 01-dsf-plugin-firstboot/
#       ├── 01-run.sh                        ← this file
#       └── files/
#           ├── ExecOnMcode-0.7-v3.6.0.zip   ← plugin zip(s) to install
#           ├── install-dsf-plugin.sh
#           └── dsf-plugin-firstboot.service

set -euo pipefail

STAGE_DIR="$(dirname "$0")/files"

# ── 1. Drop the plugin zip(s) into the image ───────────────────────────────────
install -d "${ROOTFS_DIR}/opt/dsf-plugins-pending"

for zip in "${STAGE_DIR}"/*.zip; do
    install -m 644 "$zip" "${ROOTFS_DIR}/opt/dsf-plugins-pending/"
done

# Create the flag file that the service ConditionPathExists checks
touch "${ROOTFS_DIR}/opt/dsf-plugins-pending/.pending"

# ── 2. Install the installer script ───────────────────────────────────────────
install -m 755 "${STAGE_DIR}/install-dsf-plugin.sh" \
    "${ROOTFS_DIR}/usr/local/bin/install-dsf-plugin.sh"

# ── 3. Install and enable the systemd service ─────────────────────────────────
install -m 644 "${STAGE_DIR}/dsf-plugin-firstboot.service" \
    "${ROOTFS_DIR}/etc/systemd/system/dsf-plugin-firstboot.service"

# Enable the service (creates the symlink in multi-user.target.wants)
ln -sf /etc/systemd/system/dsf-plugin-firstboot.service \
    "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/dsf-plugin-firstboot.service"

echo "DSF plugin first-boot installer staged successfully."