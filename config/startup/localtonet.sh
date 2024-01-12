#!/bin/bash

source ~/.config/MrauuScript/globals.sh

key=$(cat $AlertConf/ltn-auth)

cd $bin/alerts/localtonet/
sudo screen -dmS "localtonet" sudo -u $UnprivilegedUser ./localtonet authtoken $key || echo "[FATAL][startup-localtonet] Unhandled exception. Returned $?"
