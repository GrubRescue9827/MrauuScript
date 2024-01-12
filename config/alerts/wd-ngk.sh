#!/bin/bash
source ~/.config/MrauuScript/globals.sh

curl -s https://api.ngrok.com/tunnels -H "authorization: Bearer $(cat $AlertConf/ngk-api)" -H "ngrok-version: 2"
