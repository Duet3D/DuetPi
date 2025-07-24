#!/bin/bash

# File: stage-duetwebcontrol-plugins/04-install-plugins/files/install_plugins.sh
# Script per installare i plugin DuetWebControl usando PluginManager

LOG_FILE="/var/log/duet_plugin_install.log"
MARKER_FILE="/var/lib/duet_plugins_installed"
PLUGIN_MANAGER="/opt/dsf/bin/PluginManager"

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

# Verify PluginManager exists
if [ ! -x "$PLUGIN_MANAGER" ]; then
    log_message "ERROR: PluginManager not found at $PLUGIN_MANAGER"
    exit 1
fi

log_message "Using PluginManager at: $PLUGIN_MANAGER"

# Wait for DSF to be fully ready
log_message "Waiting for DSF to be ready..."
for i in {1..30}; do
    if [ -S /var/run/dsf/dcs.sock ]; then
        log_message "DSF socket found"
        break
    fi
    log_message "Waiting for DSF socket... ($i/30)"
    sleep 2
done

if [ ! -S /var/run/dsf/dcs.sock ]; then
    log_message "ERROR: DSF socket not found after 60 seconds"
    exit 1
fi

# Verify DSF is responding
log_message "Testing DSF connection..."

# First, ensure all required services are running
log_message "Checking DSF services status..."

# Check and start duetcontrolserver
if ! systemctl is-active --quiet duetcontrolserver; then
    log_message "Starting duetcontrolserver..."
    systemctl start duetcontrolserver
    sleep 8
else
    log_message "duetcontrolserver is already running"
fi

# Check and start duetpimanagementplugin (root plugin service)
if ! systemctl is-active --quiet duetpimanagementplugin; then
    log_message "Starting duetpimanagementplugin..."
    systemctl start duetpimanagementplugin
    sleep 8
else
    log_message "duetpimanagementplugin is already running"
fi

# Check and start duetpluginservice (critical for plugin operations)
if ! systemctl is-active --quiet duetpluginservice; then
    log_message "Starting duetpluginservice..."
    systemctl start duetpluginservice
    sleep 8
else
    log_message "duetpluginservice is already running"
fi

# Check and start duetwebserver if available
if systemctl list-unit-files | grep -q duetwebserver; then
    if ! systemctl is-active --quiet duetwebserver; then
        log_message "Starting duetwebserver..."
        systemctl start duetwebserver
        sleep 5
    else
        log_message "duetwebserver is already running"
    fi
fi

# Wait for all services to be fully ready
log_message "Waiting for all services to be fully initialized..."
sleep 15

# Now test if PluginManager can communicate properly
log_message "Testing PluginManager communication..."
if ! timeout 20 "$PLUGIN_MANAGER" list > /dev/null 2>&1; then
    log_message "ERROR: PluginManager still not responding after starting services"
    log_message "Service status diagnostics:"
    systemctl status duetcontrolserver --no-pager -l | tee -a "$LOG_FILE"
    systemctl status duetpimanagementplugin --no-pager -l | tee -a "$LOG_FILE"
    systemctl status duetpluginservice --no-pager -l | tee -a "$LOG_FILE"
    exit 1
fi

log_message "All DSF services are running and responding correctly"

# Install plugins using PluginManager
if [ -d /opt/duet_plugins ]; then
    log_message "Found plugins directory, installing plugins..."
    
    for plugin_zip in /opt/duet_plugins/*.zip; do
        if [ -f "$plugin_zip" ]; then
            plugin_name=$(basename "$plugin_zip" .zip)
            log_message "Installing plugin: $plugin_name from $plugin_zip"
            
            # Install plugin with better error handling
            log_message "Attempting to install $plugin_name..."
            install_output=$("$PLUGIN_MANAGER" install "$plugin_zip" 2>&1)
            install_result=$?
            
            echo "$install_output" | tee -a "$LOG_FILE"
            
            if [ $install_result -eq 0 ]; then
                log_message "Successfully installed $plugin_name"
                
                # Wait a moment for plugin to be registered
                sleep 3
                
                # Try to start the plugin with better error handling
                log_message "Attempting to start $plugin_name..."
                start_output=$("$PLUGIN_MANAGER" start "$plugin_name" 2>&1)
                start_result=$?
                
                echo "$start_output" | tee -a "$LOG_FILE"
                
                if [ $start_result -eq 0 ]; then
                    log_message "Successfully started $plugin_name"
                else
                    log_message "Warning: Could not start $plugin_name automatically (exit code: $start_result)"
                fi
            else
                log_message "Error: Failed to install $plugin_name (exit code: $install_result)"
            fi
        fi
    done
    
    # List installed plugins
    log_message "Listing current installed plugins:"
    "$PLUGIN_MANAGER" list 2>&1 | tee -a "$LOG_FILE"
    
    # Clean up plugin ZIP files after installation
    log_message "Cleaning up plugin files..."
    rm -rf /opt/duet_plugins
else
    log_message "No plugins directory found at /opt/duet_plugins"
fi

# Create marker file to indicate installation is complete
touch "$MARKER_FILE"
log_message "DuetWebControl plugin installation completed - marker file created"

exit 0