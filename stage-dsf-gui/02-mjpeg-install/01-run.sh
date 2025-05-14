#!/bin/bash -e
on_chroot << EOF
mkdir -p /usr/local/share/mjpg-streamer/
EOF

install -m 755 files/mjpg_streamer "${ROOTFS_DIR}/usr/local/bin/mjpg_streamer"
install -m 755 files/livestream.sh "${ROOTFS_DIR}/etc/init.d/livestream.sh"
rsync -a files/usr-local-bin/ "${ROOTFS_DIR}/usr/local/bin"
rsync -a files/usr-local-lib-mjpg-streamer/ "${ROOTFS_DIR}/usr/local/lib/mjpg-streamer/"
rsync -a files/usr-local-share-mjpg-streamer-www/ "${ROOTFS_DIR}/usr/local/share/mjpg-streamer/www/"

on_chroot << EOF
	chown root:root /usr/local/bin/mjpg_streamer
	chmod 755 /usr/local/bin/mjpg_streamer
	chown root:root /usr/local/lib/mjpg-streamer/*
	chown root:root /usr/local/share/mjpg-streamer/www/*
	chown root:root /etc/init.d/livestream.sh
	chmod 755 /etc/init.d/livestream.sh
	update-rc.d livestream.sh defaults
EOF