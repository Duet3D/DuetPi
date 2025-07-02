
install -m 644 files/nodered.service "${ROOTFS_DIR}/etc/systemd/system/nodered.service"

on_chroot << 'EOF'
# Abilita Node-RED come servizio systemd
systemctl enable nodered.service
EOF