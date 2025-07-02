#!/bin/bash -e

# Abilito i servizi con ln -sf (non uso systemctl in chroot)
ln -sf /lib/systemd/system/tailscaled.service /etc/systemd/system/multi-user.target.wants/tailscaled.service
ln -sf /etc/systemd/system/firstboot-tailscale.service /etc/systemd/system/multi-user.target.wants/firstboot-tailscale.service
