#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][server-update] Config file not found: $globals"
    exit 1
fi

# Dirty little hack to prevent API from returning NULL.
if [[ $MCCurrentVer == "latest" ]]; then
    # Mega dirty hack.
    # Why TF is this the only way I can get this to work?
    # If someone smarter than me can figure out how to
    # get this to work by overwriting the same variable
    # I will literally kiss you.
    MCTMP=$(curl -s -X 'GET' 'https://api.purpurmc.org/v2/purpur' -H 'accept: */*' | tac | tac | jq | jq -r '.versions | max')
fi

source $getlatestver
echo "Current version is:"
cd $MCInstall
$javaverget

read -r -p "Do you wish to upgrade the server? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        curl --output "$MCInstall/server.jar" --location "https://api.purpurmc.org/v2/purpur/$MCTMP/latest/download"
        ;;
    *)
        echo "[WARN] User aborted server upgrade."
        ;;
esac
