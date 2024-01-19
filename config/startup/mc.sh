#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][startup-mc] Config file not found: $globals"
    exit 1
fi

cd $MCInstall

sudo screen -dmS "minecraft" $javastartup || echo "[FATAL][startup-mc] Unhandled exception. Returned $?"
