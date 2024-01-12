#!/bin/bash

source ~/.config/MrauuScript/globals.sh

export BARGS_VARS_PATH="$MrauuConfig/srvmsg"
source $BargsLoc "$@"

send () {
    # Actually send whatever's in the buffer

    # Append enter to the end of text to make it send.
    message=$message$(printf \\r)
    #./test.sh "$text"
    sudo screen -S $screenname -X stuff "$message" || echo "[FATAL] Unhandled exception: screen returned $? - Is the server running?" && exit 1
    #echo "[DEBUG][servermsg] $message"
}

format () {
    # Create a pretty colored message for the players with the tellraw command.
    message="tellraw @a {\"text\":\"[Server]\",\"color\":\"yellow\",\"extra\":[{\"text\":\"$(echo " $message")\",\"color\":\"red\"}]}"
}

if [ $execute == n ]; then
    format
    send
    echo "[INFO][servermsg] Message sent."
else
    send
    echo "[INFO][servermsg] Command sent."
fi
