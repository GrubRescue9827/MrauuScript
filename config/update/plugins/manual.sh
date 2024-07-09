#!/bin/bash

globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][plugins-update] Config file not found: $globals"
    exit 1
fi

if [[ ! -f $pluginslist ]]; then
    echo "[FATAL][plugins-update] Plugins list not found: $pluginslist"
    exit 1
fi

echo "[INFO][plugins-update] Beginning manual plugins download..."

# Add everything in file to a temp array
while read -r line; do
  ARRAY+=("$line")
done < "$pluginslist"

# Array to store user input
ToDL=()

# Parse CSV and ask for download URL from user
for line in "${ARRAY[@]}"; do
    IFS=',' read -r col1 col2 col3 <<< "$line"
    echo "For plugin: $col1"
    echo "$col2"

    # Get the shmuck at the keyboard to scrape the website for me.
    read -p "Enter jarfile Download URL: " input
    ToDL+=("$input")
done

echo "[INFO][plugins-update] No further user input required!"

# Parse CSV AGAIN. This is probably really bad but oh wells.
for i in "${!ARRAY[@]}"; do
    IFS=',' read -r col1 col2 col3 <<< "${ARRAY[$i]}"

    # Grab the scraped URL from last step
    url="${ToDL[$i]}"

    # Download the plugin as gameuser and name it correctly
    # use gameuser to prevent permissions issues.
    sudo -u $UnprivilegedUser curl --location --output "$MCInstall/plugins/$col1" $url
done
