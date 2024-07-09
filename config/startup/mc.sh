#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][startup-mc] Config file not found: $globals"
    exit 1
fi

if [[ "$1" == "--help" ]]; then
    echo "Usage: mc.sh [OPTIONS]"
    echo "    --debug        Prints all output to terminal instead of gnu/screen, allowing for easy scrollback. Useful for debugging crashes on startup!"
    exit 0
fi

cd $MCInstall
if [[ "$1" == "--debug" ]]; then
    echo "[WARN][startup-mc] command line flag --debug was specified. Some functionality may not be available."
    $javastartup
else
    sudo screen -dmS "minecraft" $javastartup || $fatal "[FATAL][startup-mc] Unhandled exception. Returned $?"
fi
