#!/bin/bash
set -e

# Clona e compila uStreamer
cd /opt
git clone https://github.com/pikvm/ustreamer.git
cd ustreamer
make USE_LIBCAMERA=0

# Installa binario
install -v -m 755 ustreamer /usr/local/bin/ustreamer

# Crea utente dedicato
useradd -r -s /usr/sbin/nologin ustreamer

# Crea servizio systemd ottimizzato per Pi4
cat <<EOF > /etc/systemd/system/ustreamer.service
[Unit]
Description=uStreamer MJPEG streaming server
After=network.target

[Service]
ExecStart=/usr/local/bin/ustreamer \\
  --device=/dev/video0 \\
  --format=mjpeg \\
  --resolution=1280x720 \\
  --desired-fps=15 \\
  --persistent \\
  --no-log-colors \\
  --drop-same-frames \\
  --host=0.0.0.0 \\
  --port=8080 \\
  --user=ustreamer
User=ustreamer
Group=ustreamer
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Abilita il servizio
systemctl enable ustreamer.service
