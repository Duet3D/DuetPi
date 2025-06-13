#!/bin/bash -e

# Aggiungi repo Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg

curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.list   | sed 's/^deb /deb [signed-by=\/usr\/share\/keyrings\/tailscale-archive-keyring.gpg] /'   | tee /etc/apt/sources.list.d/tailscale.list

apt-get update
apt-get install -y tailscale
