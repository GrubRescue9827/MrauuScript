#!/bin/bash
# Parses github API links (See Ex.) for latest downloadable release.
# Ex: ViaVersion
# https://api.github.com/repos/ViaVersion/ViaVersion/releases/latest

# Naively looks for .jar files to download with GREP.
# This will probably break if there's more than 1 jarfile. Too bad!


# Setup vars
if [ $1 != "latest" ]; then
    echo "[FATAL][GIT-DL] GIT-DL does not support specifying a version."
    exit
fi
name="$3"
url="$2"


echo "[INFO][GIT-DL] Fetching plugin '$name'"
curl $url | grep ".browser_download_url.*jar" | cut -d : -f 2,3 | tr -d \" | xargs curl --output $name --location
ec=$?
if [ $ec == 0 ]; then
    echo "[INFO][GIT-DL] Finished fetching plugin '$name'"
else
    echo "[ERROR][GIT-DL] Returned exit code '$ec' when attempting to download from URL '$url' to file '$name'" 
fi