#!/bin/bash

install -m 644 files/config.g -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/sd/sys/config.g"
install -m 644 files/plugins.txt -o 996 -g 996 "${ROOTFS_DIR}/opt/dsf/conf/plugins.txt"

on_chroot << EOF
systemctl enable duetcontrolserver
systemctl enable duetwebserver
systemctl enable duetpluginservice
systemctl enable duetpluginservice-root

gpasswd -a pi dsf
gpasswd -a dsf video
EOF
