#!/bin/bash

# Disable unattended-upgrades service, it should be run manually using M997
on_chroot << EOF
systemctl disable unattended-upgrades.service
EOF

