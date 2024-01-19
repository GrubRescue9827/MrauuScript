#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][mcupdate] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/mcupdate"
source $BargsLoc "$@"


# Permission check
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR][mcupdate] This script must be run as root"
  exit 1
fi

# Check if server is already running
if pgrep -x "java" > /dev/null
then
	echo "[INFO][mcupdate] Server is already running! Attempting to stop..."
	$stop -r "Shutting down to update in "
    wasrunning=1
else
    wasrunning=0
fi

# OS upgrade
if [ $skip_os == y ]; then
    echo "[WARN][mcupdate] Override: skipping OS upgrade!"
else
    echo "[INFO][mcupdate] Beginning os upgrade..."
    $osupgrade
fi

# Server upgrade
if [ $skip_server == y ]; then
    echo "[WARN][mcupdate] Override: skipping server upgrade!"
else
    echo "[INFO][mcupdate] Beginning backup..."
    $BackupCommand
    echo "[INFO][mcupdate] Beginning server upgrade..."
	$updateserverconf/server.sh
fi

# Plugins upgrade
if [ $skip_plugins == y ]; then
    echo "[WARN][mcupdate] Override: skipping plugin upgrades!"
else
    echo "[INFO][mcupdate] Beginning plugin upgrades..."
    $plupdate
fi

# Restart server
if [ "$wasrunning" == "1" ]; then
	if [ $skip_restart == y ]; then
		echo "[WARN][mcupdate] Override: Server will not be restarted due to user choice."
	else
		echo "[INFO][mcupdate] Upgrade complete, restarting!"
        $run
	fi
fi
