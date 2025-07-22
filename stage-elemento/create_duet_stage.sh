#!/bin/bash -e

# Script per creare lo stage duetwebcontrol-plugins per pi-gen
# Uso: ./create_duet_stage.sh

STAGEDIR="."

echo "Creando struttura stage DuetWebControl Plugins..."

# Crea la struttura delle directory
mkdir -p "${STAGEDIR}/04-install-plugins/files"
mkdir -p "${STAGEDIR}/04-install-plugins/plugins"

# Crea prerun.sh
cat > "${STAGEDIR}/prerun.sh" << 'EOF'
#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
    copy_previous
fi
EOF

# Rendi eseguibile prerun.sh
chmod +x "${STAGEDIR}/prerun.sh"

echo "Stage DuetWebControl Plugins creato in: ${STAGEDIR}"
echo ""
echo "File creati:"
echo "- ${STAGEDIR}/prerun.sh"
echo "- ${STAGEDIR}/04-install-plugins/ (directory)"
echo "- ${STAGEDIR}/04-install-plugins/files/ (directory per script)"
echo "- ${STAGEDIR}/04-install-plugins/plugins/ (directory per file ZIP)"
echo ""
echo "Prossimi passi:"
echo "1. Salva i file rimanenti nelle loro posizioni"
echo "2. Copia i plugin ZIP in: ${STAGEDIR}/04-install-plugins/plugins/"
echo "3. Aggiungi lo stage alla STAGE_LIST di pi-gen"