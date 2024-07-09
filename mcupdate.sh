#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][mcupdate] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/mcupdate"
source $BargsLoc "$@"


# Permission check
if [[ $EUID -ne 0 ]]; then
  $error "[ERROR][mcupdate] This script must be run as root"
  exit 1
fi

# Check if server is already running
if pgrep -x "java" > /dev/null
then
	$info "[INFO][mcupdate] Server is already running! Attempting to stop..."
	$stop -s mc -r "Shutting down to update in "
    wasrunning=1
else
    wasrunning=0
fi

# OS upgrade
if [ $skip_os == y ]; then
    $warn "[WARN][mcupdate] Override: skipping OS upgrade!"
else
    $info "[INFO][mcupdate] Beginning os upgrade..."
    $osupgrade
fi

# Server upgrade
if [ $skip_server == y ]; then
    $warn "[WARN][mcupdate] Override: skipping server upgrade!"
else
    $info "[INFO][mcupdate] Beginning backup..."
    $BackupCommand
    $info "[INFO][mcupdate] Beginning server upgrade..."
	$updateserverconf/server.sh
fi

# Plugins upgrade
if [ $skip_plugins == y ]; then
    $warn "[WARN][mcupdate] Override: skipping plugin upgrades!"
else
    $info "[INFO][mcupdate] Beginning plugin upgrades..."
    $plupdate
fi

# Restart server
if [ "$wasrunning" == "1" ]; then
	if [ $skip_restart == y ]; then
		$warn "[WARN][mcupdate] Override: Server will not be restarted due to user choice."
	else
		$info "[INFO][mcupdate] Upgrade complete, restarting!"
        $run
	fi
fi
