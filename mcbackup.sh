#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][backup] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/mcbackup"
source $BargsLoc "$@"

# Sanity check
if [[ "$BackupLoc" == "" ]]; then
	$fatal "[FATAL][backup] Backup directory does not exist!"
	exit 1
fi

# Inputs are OK
$info "[INFO][backup] Begin backup..."

# Check if running override-checks mode
# TODO: figure out why we're doing this?
if [ $skip_server_checks == force_yes ]; then
	skip=1
	else
	# Prompt user in interactive mode.
	if [ $skip_server_checks == y ]; then
		$warn "[WARN][backup] Running with override in interactive mode."
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
			$warn "[WARN][backup] User chose to enable override."
			skip=1
		else
			$fatal "[FATAL][backup] User aborted backup."
			exit 1
		fi
	else
	skip=0
	fi
fi

if [ "$skip" == "0" ]; then
	# Check if the server is running
	if pgrep -x "java" > /dev/null
	then
		$info "[INFO][backup] Server is running, attempting shutdown!"
		$stop -r "Shutting down for backup in " -s mc
		wasrunning=1
	else
		$info "[INFO][backup] Server is not running, skipping shutdown."
		wasrunning=0
	fi
fi

# Delete last x backups
if [[ "$delete_last" != "0" ]] || [[ "$BackupKeepLast" != "" ]]; then
	$info "[INFO][backup] Cleaning up backups folder..."
	cd "$BackupLoc"

	# Count the number of files (excluding directories) in the directory
	CurrentBackupCount=$(find . -maxdepth 1 -type f | wc -l)

	# Calculate the number of backups to delete
	let "BackupsToDelete = $CurrentBackupCount - $BackupKeepLast"

	# Check if there are more than x files
	if [ $BackupsToDelete -gt 0 ]; then
	# Delete the oldest files
	ls -tp | grep -v '/$' | tail -n "$BackupsToDelete" | xargs -I {} rm -v -- {}
	else
		$info "[INFO][backup] Backups folder does not need cleaning."
	fi
fi


# Create backup folder if it doesn't exist
#mkdir -p $BackupLoc
tar -v -czf $BackupLoc/$BackupName $MCInstall

if [[ "$wasrunning" == "1" ]]; then
	$info "[INFO][backup] Rebooting server..."
	$run -r mc
fi
