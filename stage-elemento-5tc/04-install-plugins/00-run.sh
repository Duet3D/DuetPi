#!/bin/bash -e

# File: stage-duetwebcontrol-plugins/04-install-plugins/04-run.sh
# Script principale per l'installazione dei plugin DuetWebControl

# Copia lo script di installazione dei plugin
install -m 755 files/install_plugins.sh "${ROOTFS_DIR}/usr/local/bin/install_duet_plugins.sh"

# Copia i file ZIP dei plugin se esistono
if [ -d plugins ] && [ "$(ls -A plugins)" ]; then
    echo "Trovati plugin ZIP, li copio nell'immagine..."
    install -d "${ROOTFS_DIR}/opt/duet_plugins"
    install -m 644 plugins/*.zip "${ROOTFS_DIR}/opt/duet_plugins/" 2>/dev/null || true
else
    echo "Nessun plugin ZIP trovato nella directory plugins/"
fi

# Crea la directory per rc.local.d se non esiste
install -d "${ROOTFS_DIR}/etc/rc.local.d"

# Crea lo script rc.local per l'installazione dei plugin
cat > "${ROOTFS_DIR}/etc/rc.local.d/install_duet_plugins.sh" << 'RCLOCAL'
#!/bin/bash
# Install DuetWebControl plugins after first boot and filesystem expansion

MARKER_FILE="/var/lib/duet_plugins_installed"

# Check if plugins have already been installed
if [ -f "$MARKER_FILE" ]; then
    # Plugins already installed, remove this script
    rm /etc/rc.local.d/install_duet_plugins.sh
    exit 0
fi

# Wait for DSF to be ready
sleep 20

# Check if plugins need to be installed
if [ -d /opt/duet_plugins ] && [ "$(ls -A /opt/duet_plugins)" ]; then
    /usr/local/bin/install_duet_plugins.sh
    
    # Create marker file to indicate installation is complete
    touch "$MARKER_FILE"
    
    # Remove this script after execution
    rm /etc/rc.local.d/install_duet_plugins.sh
else
    # No plugins to install, create marker and remove script
    touch "$MARKER_FILE"
    rm /etc/rc.local.d/install_duet_plugins.sh
fi

exit 0
RCLOCAL

# Rendi eseguibile lo script rc.local
chmod +x "${ROOTFS_DIR}/etc/rc.local.d/install_duet_plugins.sh"

# Crea o modifica rc.local per supportare rc.local.d
if [ ! -f "${ROOTFS_DIR}/etc/rc.local" ]; then
    echo "Creando rc.local con supporto per rc.local.d..."
    cat > "${ROOTFS_DIR}/etc/rc.local" << 'RCLOCAL_CONTENT'
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Execute scripts in rc.local.d
if [ -d /etc/rc.local.d ]; then
    for script in /etc/rc.local.d/*.sh; do
        if [ -x "$script" ]; then
            "$script"
        fi
    done
fi

exit 0
RCLOCAL_CONTENT
    chmod +x "${ROOTFS_DIR}/etc/rc.local"
    echo "rc.local creato con successo"
elif ! grep -q "rc.local.d" "${ROOTFS_DIR}/etc/rc.local" 2>/dev/null; then
    echo "Aggiungendo supporto per rc.local.d in rc.local esistente..."
    # Crea una copia di backup
    cp "${ROOTFS_DIR}/etc/rc.local" "${ROOTFS_DIR}/etc/rc.local.backup"
    
    # Aggiungi l'esecuzione di rc.local.d prima di exit 0
    sed -i '/^exit 0/i\
# Execute scripts in rc.local.d\
if [ -d /etc/rc.local.d ]; then\
    for script in /etc/rc.local.d/*.sh; do\
        if [ -x "$script" ]; then\
            "$script"\
        fi\
    done\
fi' "${ROOTFS_DIR}/etc/rc.local"
    echo "Supporto rc.local.d aggiunto a rc.local esistente"
else
    echo "rc.local esiste già e ha il supporto per rc.local.d"
fi

echo "Configurazione plugin DuetWebControl completata"