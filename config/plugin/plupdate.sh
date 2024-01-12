#!/bin/bash

if [ $1 == "" ]; then
    ver="latest"
else
    ver=$1
fi

# SkinsRestorer
#github.sh "https://api.github.com/repos/SkinsRestorer/SkinsRestorerX/releases/latest" "SkinsRestorer.jar"

# Geyser
#generic.sh "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot" "Geyser.jar"

# Floodgate
#generic.sh "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot" "Floodgate.jar"
#generic.sh "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/database/sqlite/build/libs/floodgate-sqlite-database.jar" "./floodgate/floodgate-sqlite-database.jar"

# Viaversion
#./github.sh "$ver" "https://api.github.com/repos/ViaVersion/ViaVersion/releases/latest" "ViaVersion.jar"

# ViaBackwards
#github.sh "https://api.github.com/repos/ViaVersion/ViaVersion/releases/latest" "ViaVersion.jar"

