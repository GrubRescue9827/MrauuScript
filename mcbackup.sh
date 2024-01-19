#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][mcbackup] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/mcbackup"
source $BargsLoc "$@"

echo "[INFO][mcbackup] Begin backup..."

# Check if running override-checks mode
if [ $skip_server_checks == force_yes ]; then
	skip=1
	else
	# Prompt user in interactive mode.
	if [ $skip_server_checks == y ]; then
		echo "[WARN] Running with override in interactive mode."
		echo "============================================================="
		echo "|  You are running this script with --skip-server-checks    |"
		echo "|  This override disables all sanity checks.                |"
		echo "|                                                           |"
		echo "|  Are you ABSOLUTELY sure you wish to do this?             |"
		echo "============================================================="
		echo -n "To continue, please type \"Yes, do as I say!\""
		echo
		read user_enabled_override
		if [ "$user_enabled_override" == "Yes, do as I say!" ]; then
			echo "[WARN] User chose to enable override."
			skip=1
		else
			echo "[FATAL] User aborted backup."
			exit 1
		fi
	else
	skip=0
	fi
fi

if [ skip == 0 ]; then
	# Check if the server is running
	if pgrep -x "java" > /dev/null
	then
		echo "[WARN] Server is running, attempting shutdown!"
		$stop -r "Shutting down for backup in "
		wasrunning=1
	else
		echo "[INFO] Server is not running, skipping shutdown."
		wasrunning=0
	fi
fi

# Create backup folder if it doesn't exist
#mkdir -p $BackupLoc
echo tar -v -czf $BackupLoc/$BackupName $MCInstall
