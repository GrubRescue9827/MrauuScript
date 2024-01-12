#!/bin/bash

# Setup vars
if [ $1 != "latest" ]; then
    echo "[FATAL][GENERIC-DL] GENERIC-DL does not support specifying a version."
    exit
fi
name="$3"
url="$2"

echo "[INFO][GENERIC-DL] Fetching plugin '$name'"
curl --output $name --location $url
echo "[INFO][GENERIC-DL] Finished fetching plugin '$name'"
