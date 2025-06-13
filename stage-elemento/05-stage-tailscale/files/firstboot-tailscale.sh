#!/bin/bash

FLAG_FILE="/etc/firstboot-tailscale.done"
AUTHKEY_FILE="/boot/tailscale.authkey"
LOG_FILE="/var/log/firstboot-tailscale.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "==== FIRST BOOT TAILSCALE SETUP ===="
date

# Se il flag esiste, non fare nulla
if [ -f "$FLAG_FILE" ]; then
    echo "Setup già completato in precedenza."
    exit 0
fi

# Se il file authkey esiste, leggo la chiave
if [ -f "$AUTHKEY_FILE" ]; then
    echo "File $AUTHKEY_FILE trovato, procedo a leggere la auth-key."
    AUTHKEY=$(cat "$AUTHKEY_FILE" | tr -d ' \t\n\r')
    if [[ "$AUTHKEY" =~ ^tskey- ]]; then
        echo "Auth-key valida trovata, eseguo login automatico..."
        tailscale up --authkey="$AUTHKEY"
        TS_EXIT_CODE=$?
        if [ $TS_EXIT_CODE -eq 0 ]; then
            echo "Login automatico completato con successo."
            echo "Rimuovo file $AUTHKEY_FILE per sicurezza."
            rm -f "$AUTHKEY_FILE"
        else
            echo "Errore durante 'tailscale up' (exit code $TS_EXIT_CODE)."
            echo "Non rimuovo il file authkey per permettere retry."
        fi
    else
        echo "ATTENZIONE: il file $AUTHKEY_FILE non contiene una auth-key valida (deve iniziare con 'tskey-')."
        echo "Puoi eseguire manualmente 'sudo tailscale up' in un terminale in seguito."
    fi
else
    # Controllo se terminale è interattivo
    if [ -t 0 ]; then
        echo "Vuoi configurare ora Tailscale VPN? (y/n) "
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "Eseguo 'tailscale up' interattivo..."
            tailscale up
        else
            echo "Puoi eseguire manualmente 'sudo tailscale up' in seguito."
        fi
    else
        echo "Terminale non interattivo e nessuna auth-key in /boot/, salto il setup di Tailscale."
        echo "Puoi eseguire 'sudo tailscale up' in un terminale in seguito."
    fi
fi

touch "$FLAG_FILE"
echo "Flag $FLAG_FILE creato, il setup non verrà ripetuto al prossimo boot."

systemctl disable firstboot-tailscale.service
echo "Servizio firstboot-tailscale disabilitato."
