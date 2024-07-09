#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][servermsg] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/srvmsg"
source $BargsLoc "$@"

send () {
    # Actually send whatever's in the buffer

    # Append enter to the end of text to make it send.
    message=$message$(printf \\r)
    sudo screen -S $screenname -X stuff "$message" || $fatal "[FATAL] Unhandled exception: screen returned $? - Is the server running?" && exit 1
}

format () {
    # Create a pretty colored message for the players with the tellraw command.
    message="tellraw @a {\"text\":\"[Server]\",\"color\":\"yellow\",\"extra\":[{\"text\":\"$(echo " $message")\",\"color\":\"red\"}]}"
}

if [ $execute == n ]; then
    format
    send
    $info "[INFO][servermsg] Message sent."
else
    send
    $info "[INFO][servermsg] Command sent."
fi
