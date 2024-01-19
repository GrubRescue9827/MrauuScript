#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][startup-localtonet] Config file not found: $globals"
    exit 1
fi

key=$(cat $AlertConf/ltn-auth)

cd $bin/alerts/localtonet/
sudo screen -dmS "localtonet" sudo -u $UnprivilegedUser ./localtonet authtoken $key || echo "[FATAL][startup-localtonet] Unhandled exception. Returned $?"
