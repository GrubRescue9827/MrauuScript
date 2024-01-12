#!/bin/bash

source ~/.config/MrauuScript/globals.sh

cd $MCInstall

sudo screen -dmS "minecraft" sudo -u $UnprivilegedUser java -Xms2000M -Xmx3500M --add-modules=jdk.incubator.vector -jar ./server.jar --nogui || echo "[FATAL][startup-mc] Unhandled exception. Returned $?"
