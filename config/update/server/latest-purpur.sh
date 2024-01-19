#!/bin/bash

globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][latest-purpur] Config file not found: $globals"
    exit 1
fi


build=$(curl -s -X 'GET' "https://api.purpurmc.org/v2/purpur/$MCTMP/" -H 'accept: */*' | tac | tac | jq | jq -r '.builds.latest')

echo "--- [INFO][latest-purpur] ---"
echo "Latest applicable build of Purpur is:"
echo "$MCTMP-$build"
echo "--- END ---"
