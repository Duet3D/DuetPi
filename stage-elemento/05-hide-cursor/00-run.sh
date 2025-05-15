#!/bin/bash -e

echo "🎯 Imposto cursore invisibile per l'utente 'pi'..."

USER_HOME="${ROOTFS_DIR}/home/pi"
CURSOR_DIR="${USER_HOME}/.icons/blank-cursor"

# Crea cartelle
install -d "$CURSOR_DIR/cursors"

# Crea cursore trasparente
dd if=/dev/zero of="$CURSOR_DIR/cursors/left_ptr" bs=1 count=1 status=none

# Crea index.theme
cat <<EOF > "$CURSOR_DIR/index.theme"
[Icon Theme]
Name=Blank
Comment=Invisible cursor
EOF

# Imposta il tema cursore all'avvio utente
echo 'export XCURSOR_THEME=blank-cursor' >> "${USER_HOME}/.profile"
echo 'Xcursor.theme: blank-cursor' >> "${USER_HOME}/.Xresources"

# Permessi corretti
chown -R 1000:1000 "${USER_HOME}/.icons"
