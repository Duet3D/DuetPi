#!/bin/bash

FLAG_FILE="/etc/firstboot-tailscale.done"
CONF_FILE="/boot/firmware/TC.conf"
LOG_FILE="/var/log/firstboot-tailscale.log"

exec > >(tee -a "$LOG_FILE") 2>&1
echo "==== FIRSTBOOT TAILSCALE SETUP ===="
date

if [ -f "$FLAG_FILE" ]; then
    echo "Already configured, skipping."
    exit 0
fi

if [ ! -f "$CONF_FILE" ]; then
    echo "TC.conf not found at $CONF_FILE — skipping tailscale setup."
    systemctl disable firstboot-tailscale.service
    touch "$FLAG_FILE"
    exit 0
fi

# Legge variabili nel formato: ; CHIAVE="valore"
parse_conf() {
    grep -oP "(?<=; $1=\")[^\"]+" "$CONF_FILE" 2>/dev/null | head -1
}

TAILSCALE_AUTHKEY=$(parse_conf "TAILSCALE_AUTHKEY")
TAILSCALE_HOSTNAME=$(parse_conf "TAILSCALE_HOSTNAME")
PRINTER_SERIAL=$(parse_conf "PRINTER_SERIAL")
TAILSCALE_SSH=$(parse_conf "TAILSCALE_SSH")
TAILSCALE_ACCEPT_DNS=$(parse_conf "TAILSCALE_ACCEPT_DNS")

echo "Printer serial  : ${PRINTER_SERIAL:-N/A}"
echo "Tailscale host  : ${TAILSCALE_HOSTNAME:-<auto>}"
echo "SSH via tailscale: ${TAILSCALE_SSH:-0}"

if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "Nessuna TAILSCALE_AUTHKEY trovata in $CONF_FILE — skip."
    systemctl disable firstboot-tailscale.service
    touch "$FLAG_FILE"
    exit 0
fi

TS_ARGS="--authkey=$TAILSCALE_AUTHKEY"

# DNS: default disabilitato per non interferire con la rete della stampante
if [ "${TAILSCALE_ACCEPT_DNS:-0}" != "1" ]; then
    TS_ARGS="$TS_ARGS --accept-dns=false"
fi

[ -n "$TAILSCALE_HOSTNAME" ] && TS_ARGS="$TS_ARGS --hostname=$TAILSCALE_HOSTNAME"
[ "${TAILSCALE_SSH:-0}" = "1" ] && TS_ARGS="$TS_ARGS --ssh"

echo "Eseguo: tailscale up $TS_ARGS"
# shellcheck disable=SC2086
tailscale up $TS_ARGS
TS_EXIT=$?

if [ $TS_EXIT -ne 0 ]; then
    echo "ERRORE: tailscale up fallito (exit $TS_EXIT) — riprovo al prossimo avvio."
    exit 1
fi

echo "Tailscale connesso."
tailscale status >> "$LOG_FILE"

touch "$FLAG_FILE"
systemctl disable firstboot-tailscale.service
echo "Setup completato. Servizio disabilitato."
