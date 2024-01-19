#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][startup-ngrok] Config file not found: $globals"
    exit 1
fi

# If API key hasn't been imported to gameuser yet, import it automatically from MrauuScript config file.
# For some reason ~gameuser/.config/ isn't working for me. It tries to search for the LITERAL
# string "~gameuser/" and doesn't parse it as "/home/gameuser/" This means that if your home
# directory doesn't exist or is different from default, this breaks. TOO BAD!
conf=$(echo /home/$UnprivilegedUser/.config/ngrok/ngrok.yml)
if [[ ! -f $conf ]]; then
    echo "[WARN][startup-ngrok] $conf does NOT exist! Attempting to create..."

    # Technically not necessary, but just to be kind to ngrok.
    # In case it tries to save a file to the working directory,
    # it means it always stays consistent.
    key=$(cat $AlertConf/ngk-auth)    
    cd $bin/alerts/ngrok/

    sudo -u $UnprivilegedUser ./ngrok config add-authtoken $key
fi

cd $bin/alerts/ngrok/

sudo screen -dmS "ngrok" sudo -u $UnprivilegedUser ./ngrok tcp 25565 || echo "[ERROR][startup-ngrok] Unhandled exception. Returned $?"
