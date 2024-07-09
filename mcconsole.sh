#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][mcupdate] Config file not found: $globals"
    exit 1
fi

selection=$1

case "$selection" in
  "" | "1" | "mc" | "m" | "M" | "minecraft")
sudo screen -r "minecraft" || $error "[ERROR][mcconsole] Returned: $? (Is the server running?)";;
  "2" | "ltn" | "l" | "L" | "localtonet")
sudo screen -r "localtonet" || $error "[ERROR][mcconsole] Returned: $? (Is localtonet running?)";;
  "3" | "ngk" | "n" | "N" | "ngrok")
sudo screen -r "ngrok" || $error "[ERROR][mcconsole] Returned: $? (Is ngrok running?)";;
  *)
$fatal "[FATAL][mcconsole] Unknown selection \"$selection\"";;
esac
