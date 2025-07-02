#!/bin/bash

FLAG_FILE="/etc/firstboot-tailscale.done"
CONF_FILE="/boot/TC.conf"
LOG_FILE="/var/log/firstboot-tailscale.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "==== FIRST BOOT TAILSCALE SETUP ===="
date

# Se il flag esiste, non fare nulla
if [ -f "$FLAG_FILE" ]; then
    echo "Setup già completato in precedenza."
    exit 0
fi

# Se il file TC.conf esiste, leggo la variabile
if [ -f "$CONF_FILE" ]; then
    echo "File $CONF_FILE trovato, procedo a leggerlo."
    source "$CONF_FILE"
    if [[ "$TAILSCALE_AUTHKEY" =~ ^tskey- ]]; then
        echo "Auth-key valida trovata, eseguo login automatico..."
        tailscale up --authkey="$TAILSCALE_AUTHKEY"
        TS_EXIT_CODE=$?
        if [ $TS_EXIT_CODE -eq 0 ]; then
            echo "Login automatico completato con successo."
        else
            echo "Errore durante 'tailscale up' (exit code $TS_EXIT_CODE)."
        fi
    else
        echo "ATTENZIONE: nessuna auth-key valida trovata in $CONF_FILE."
        echo "Puoi eseguire manualmente 'sudo tailscale up' in un terminale in seguito."
    fi
else
    echo "File $CONF_FILE non trovato."
    echo "Puoi eseguire manualmente 'sudo tailscale up' in un terminale in seguito."
fi

touch "$FLAG_FILE"
echo "Flag $FLAG_FILE creato, il setup non verrà ripetuto al prossimo boot."

systemctl disable firstboot-tailscale.service
echo "Servizio firstboot-tailscale disabilitato."
