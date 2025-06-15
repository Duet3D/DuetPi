#!/bin/bash -e

on_chroot << 'EOF'
# Installa Node.js 18 LTS dal repo ufficiale
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Installa Node-RED come quell'utente
npm install -g --unsafe-perm node-red

# Abilita Node-RED al boot
systemctl enable nodered.service
EOF
