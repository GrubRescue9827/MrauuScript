#!/bin/bash
source ~/.config/MrauuScript/globals.sh

curl -s --location 'https://localtonet.com/api/GetTunnels' --header 'Accept: application/json' --header "Authorization: Bearer $(cat $AlertConf/ltn-api)"

