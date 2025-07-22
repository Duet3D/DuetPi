#!/bin/bash

# File: stage-duetwebcontrol-plugins/00-install-plugins/files/install_plugins.sh
# Script per installare i plugin DuetWebControl usando PluginManager

LOG_FILE="/var/log/duet_plugin_install.log"
MARKER_FILE="/var/lib/duet_plugins_installed"

# Function to log messages
log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Check if installation was already completed
if [ -f "$MARKER_FILE" ]; then
    log_message "Plugin installation already completed, skipping..."
    exit 0
fi

log_message "Starting DuetWebControl plugin installation"

# Wait for DSF to be fully ready
log_message "Waiting for DSF to be ready..."
for i in {1..30}; do
    if [ -S /var/run/dsf/dcs.sock ]; then
        log_message "DSF socket found"
        break
    fi
    sleep 2
done

# Verify DSF is responding
if ! timeout 10 PluginManager list > /dev/null 2>&1; then
    log_message "DSF not responding, restarting services..."
    systemctl restart duetcontrolserver
    sleep 10
fi

# Install plugins using PluginManager
if [ -d /opt/duet_plugins ]; then
    log_message "Found plugins directory, installing plugins..."
    
    for plugin_zip in /opt/duet_plugins/*.zip; do
        if [ -f "$plugin_zip" ]; then
            plugin_name=$(basename "$plugin_zip" .zip)
            log_message "Installing plugin: $plugin_name"
            
            if PluginManager install "$plugin_zip" 2>&1 | tee -a "$LOG_FILE"; then
                log_message "Successfully installed $plugin_name"
                
                # Try to start the plugin
                if PluginManager start "$plugin_name" 2>&1 | tee -a "$LOG_FILE"; then
                    log_message "Successfully started $plugin_name"
                else
                    log_message "Warning: Could not start $plugin_name automatically"
                fi
            else
                log_message "Error: Failed to install $plugin_name"
            fi
        fi
    done
    
    # List installed plugins
    log_message "Current installed plugins:"
    PluginManager list 2>&1 | tee -a "$LOG_FILE"
    
    # Clean up plugin ZIP files after installation
    log_message "Cleaning up plugin files..."
    rm -rf /opt/duet_plugins
else
    log_message "No plugins directory found"
fi

# Create marker file to indicate installation is complete
touch "$MARKER_FILE"
log_message "DuetWebControl plugin installation completed - marker file created"

exit 0