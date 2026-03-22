#!/bin/bash
# install-dsf-plugin.sh
# Runs once at first boot (after pi-gen first-run reboot) to install DSF plugins.
# Managed by dsf-plugin-firstboot.service — disables itself after success.

set -euo pipefail

LOG="/var/log/dsf-plugin-firstboot.log"
PLUGIN_DIR="/opt/dsf-plugins-pending"
PLUGIN_MANAGER="/opt/dsf/bin/PluginManager"
MAX_WAIT=120   # seconds to wait for DSF plugin services to be ready

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

is_service_active() {
    systemctl is-active --quiet "$1" 2>/dev/null
}

log "=== DSF Plugin First-Boot Installer ==="

# ── 1. Aspetta che DCS e i due plugin service siano active ────────────────────
log "Waiting for DSF services to become active (max ${MAX_WAIT}s)..."
elapsed=0
while true; do
    dcs_ok=false
    ps_ok=false
    psr_ok=false

    is_service_active duetcontrolserver.service      && dcs_ok=true
    is_service_active duetpluginservice.service      && ps_ok=true
    is_service_active duetpluginservice-root.service && psr_ok=true

    if $dcs_ok && $ps_ok && $psr_ok; then
        log "All DSF services are active."
        break
    fi

    if (( elapsed >= MAX_WAIT )); then
        log "ERROR: DSF services did not become active in ${MAX_WAIT}s."
        log "  duetcontrolserver:      $dcs_ok"
        log "  duetpluginservice:      $ps_ok"
        log "  duetpluginservice-root: $psr_ok"
        exit 1
    fi

    sleep 5
    (( elapsed += 5 ))
    log "  ...waiting (${elapsed}s) — dcs:$dcs_ok ps:$ps_ok ps-root:$psr_ok"
done

# ── 2. Verifica ulteriore: PluginManager risponde senza errori ────────────────
log "Verifying PluginManager responds cleanly..."
elapsed=0
until output=$("$PLUGIN_MANAGER" list 2>&1) && ! echo "$output" | grep -qi "not started\|cannot\|failed\|error"; do
    if (( elapsed >= MAX_WAIT )); then
        log "ERROR: PluginManager not ready after ${MAX_WAIT}s. Last output: $output"
        exit 1
    fi
    sleep 5
    (( elapsed += 5 ))
    log "  ...PluginManager not ready yet (${elapsed}s)"
done
log "PluginManager is ready."

# ── 3. Installa ogni .zip nella directory pending ─────────────────────────────
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
    # Copia in /tmp per aggirare ProtectHome=true del demone DSF
    tmp_copy="/tmp/$(basename "$plugin")"
    cp "$plugin" "$tmp_copy"

    log "Installing plugin: $(basename "$plugin")"
    output=$("$PLUGIN_MANAGER" install "$tmp_copy" 2>&1)
    echo "$output" >> "$LOG"

    if echo "$output" | grep -qi "failed\|error\|not started\|cannot"; then
        log "  ✗ Failed to install $(basename "$plugin")"
        log "  Output: $output"
        rm -f "$tmp_copy"
        all_ok=false
    else
        log "  ✓ Successfully installed $(basename "$plugin")"
        rm -f "$tmp_copy"
    fi
done

# ── 4. Disabilita il servizio se tutto ok ─────────────────────────────────────
if $all_ok; then
    log "All plugins installed successfully."
    systemctl disable dsf-plugin-firstboot.service >> "$LOG" 2>&1
    rm -f "${PLUGIN_DIR}/.pending"
    log "Service disabled. First-boot installation complete."
else
    log "One or more plugins failed. Service NOT disabled — will retry on next boot."
    exit 1
fi