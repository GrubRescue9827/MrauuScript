#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][wd-ltn] Config file not found: $globals"
    exit 1
fi

curl -s --location 'https://localtonet.com/api/GetTunnels' --header 'Accept: application/json' --header "Authorization: Bearer $(cat $AlertConf/ltn-api)"
