#!/bin/bash -e

on_chroot << EOF
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.gpg \
    | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg

echo 'deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bookworm main' \
    > /etc/apt/sources.list.d/tailscale.list

apt-get update
apt-get install -y tailscale
EOF
