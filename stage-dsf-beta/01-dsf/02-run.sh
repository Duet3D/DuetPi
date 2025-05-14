#!/bin/bash

install -m 644 files/config.g -o 992 -g 992 "${ROOTFS_DIR}/opt/dsf/sd/sys/config.g"
install -m 644 files/plugins.txt -o 992 -g 992 "${ROOTFS_DIR}/opt/dsf/conf/plugins.txt"

on_chroot << EOF
systemctl enable duetcontrolserver
systemctl enable duetwebserver
systemctl enable duetpluginservice
systemctl enable duetpluginservice-root

adduser $FIRST_USER_NAME dsf
adduser dsf video

chown dsf:dsf /opt/dsf/sd/sys/config.g
chown dsf:dsf /opt/dsf/conf/plugins.txt
EOF
