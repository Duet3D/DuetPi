#!/bin/bash
# install-dsf-plugin.sh
# Runs once at first boot (after pi-gen first-run reboot) to install DSF plugins.
# Managed by dsf-plugin-firstboot.service — deletes itself after success.

set -euo pipefail

LOG="/var/log/dsf-plugin-firstboot.log"
PLUGIN_DIR="/opt/dsf-plugins-pending"
PLUGIN_MANAGER="/opt/dsf/bin/PluginManager"
MAX_WAIT=120   # seconds to wait for DSF to become ready

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

log "=== DSF Plugin First-Boot Installer ==="

# ── 1. Wait for DuetControlServer to be fully operational ──────────────────────
log "Waiting for DuetControlServer to become ready (max ${MAX_WAIT}s)..."
elapsed=0
until /opt/dsf/bin/PluginManager list &>/dev/null; do
    if (( elapsed >= MAX_WAIT )); then
        log "ERROR: DuetControlServer did not become ready in ${MAX_WAIT}s. Aborting."
        exit 1
    fi
    sleep 5
    (( elapsed += 5 ))
    log "  ...still waiting (${elapsed}s elapsed)"
done
log "DuetControlServer is ready."

# ── 2. Install every .zip found in the pending directory ───────────────────────
if [[ ! -d "$PLUGIN_DIR" ]]; then
    log "Plugin directory $PLUGIN_DIR not found — nothing to install."
    exit 0
fi

shopt -s nullglob
plugins=("$PLUGIN_DIR"/*.zip)

if (( ${#plugins[@]} == 0 )); then
    log "No plugin zip files found in $PLUGIN_DIR — nothing to install."
    exit 0
fi

all_ok=true
for plugin in "${plugins[@]}"; do
    # Copy to /tmp so DSF daemon (ProtectHome=true) can read it
    tmp_copy="/tmp/$(basename "$plugin")"
    cp "$plugin" "$tmp_copy"

    log "Installing plugin: $(basename "$plugin")"
    if "$PLUGIN_MANAGER" install "$tmp_copy" >> "$LOG" 2>&1; then
        log "  ✓ Successfully installed $(basename "$plugin")"
        rm -f "$tmp_copy"
    else
        log "  ✗ Failed to install $(basename "$plugin")"
        rm -f "$tmp_copy"
        all_ok=false
    fi
done

# ── 3. Mark done — disable this service so it never runs again ─────────────────
if $all_ok; then
    log "All plugins installed successfully."
    systemctl disable dsf-plugin-firstboot.service >> "$LOG" 2>&1
    log "Service disabled. First-boot installation complete."
else
    log "One or more plugins failed to install. Service will NOT be disabled — will retry on next boot."
    exit 1
fi