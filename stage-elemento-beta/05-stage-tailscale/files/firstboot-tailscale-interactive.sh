#!/bin/bash

FLAG_FILE="/etc/firstboot-tailscale.done"
CONF_FILE="/boot/TC.conf"

# Se il flag esiste, non fare nulla
if [ -f "$FLAG_FILE" ]; then
    return
fi

echo "==== INTERACTIVE FIRST BOOT TAILSCALE SETUP ===="

# Se il file TC.conf esiste, leggo la variabile
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
    if [[ "$TAILSCALE_AUTHKEY" =~ ^tskey- ]]; then
        echo "Auth-key trovata in $CONF_FILE."
        echo "Vuoi eseguire 'tailscale up' ora? (y/n) "
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            sudo tailscale up --authkey="$TAILSCALE_AUTHKEY"
        else
            echo "Puoi eseguire manualmente 'sudo tailscale up' in seguito."
        fi
    else
        echo "Nessuna auth-key valida trovata in $CONF_FILE."
        echo "Puoi eseguire manualmente 'sudo tailscale up' in seguito."
    fi
else
    echo "File $CONF_FILE non trovato."
    echo "Puoi eseguire manualmente 'sudo tailscale up' in seguito."
fi

# Non tocco il FLAG_FILE qui (lasciato al servizio systemd)
