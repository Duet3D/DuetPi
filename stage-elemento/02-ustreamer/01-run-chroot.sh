#!/bin/bash
set -e

# Clona e compila uStreamer
#cd /opt
#git clone https://github.com/pikvm/ustreamer.git
#cd ustreamer
#make USE_LIBCAMERA=0

# Crea utente dedicato
#userdel ustreamer
useradd -r -s /usr/sbin/nologin ustreamer

usermod -aG video ustreamer


# Crea servizio systemd ottimizzato per Pi4
cat <<EOF > /etc/systemd/system/ustreamer.service
[Unit]
Description=uStreamer MJPEG streaming server
After=network.target

[Service]
ExecStart=/usr/local/bin/ustreamer \
  --device=/dev/video0 \
  --format=mjpeg \
  --resolution=1920x1080 \
  --desired-fps=15 \
  --persistent \
  --no-log-colors \
  --drop-same-frames=30 \
  --host=0.0.0.0 \
  --port=8090
User=ustreamer
Group=ustreamer
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Abilita il servizio
systemctl enable ustreamer.service
