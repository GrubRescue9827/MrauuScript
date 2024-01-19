#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][wd-ngk] Config file not found: $globals"
    exit 1
fi

curl -s https://api.ngrok.com/tunnels -H "authorization: Bearer $(cat $AlertConf/ngk-api)" -H "ngrok-version: 2"
