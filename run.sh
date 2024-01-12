#!/bin/bash

source ~/.config/MrauuScript/globals.sh

export BARGS_VARS_PATH="$MrauuConfig/run"
source $BargsLoc "$@"

# Permission check
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR][run] This script must be run as root"
  exit 1
fi

# Check if server or alerts are already running
echo "[INFO][run] Checking if server is already running..."
processes=()
processes+=("java")

if [[ -f $AlertConf/ngk-auth ]]; then
    echo "[DEBUG][run] ngrok is configured."
    processes+=("ngrok")
fi

if [[ -f $AlertConf/ltn-auth ]]; then
    echo "[DEBUG][run] localtonet is configured."
    processes+=("localtonet")
fi

for pname in "${processes[@]}"; do
    if pgrep -x $pname > /dev/null
        then
            echo "[WARN][run] Process $pname is already running."
            running+=($pname)
        else
            echo "[DEBUG][run] Not running: $pname"
    fi
done

# Kill running processes if specified to, else warn user.
if [ $running ]; then
    if [ $kill_running = y ]; then
        for process in "${running[@]}"; do
            if [ "$process" == "java" ] && [ $graceful_shutdown == "y" ]; then
                $stop -r "Restarting in "
            else
                echo "[WARN][run] Forcefuly killing process $process due to user choice."
                pkill $process
            fi
        done
    else
        echo "[FATAL][run] Process $process is already running. Cannot continue due to user choice."
        exit 1
    fi
fi

echo "[INFO][run] Starting server..."

$StartupConf/mc.sh || echo "[ERROR] Unhandled exception: $StartupConf/mc.sh returned $?"

# Start alerts if configured
# TODO: Checking these files twice is stupid and slow! TOO BAD!

if [[ -f $AlertConf/ngk-auth ]]; then
    echo "[DEBUG][run] Starting ngrok..."
    $StartupConf/ngrok.sh || echo "[ERROR] Unhandled exception: $StartupConf/ngrok.sh returned $?"
fi

if [[ -f $AlertConf/ltn-auth ]]; then
    echo "[DEBUG][run] Starting localtonet..."
    $StartupConf/localtonet.sh || echo "[ERROR] Unhandled exception: $StartupConf/localtonet.sh returned $?"
fi

if [[ -f $StartupConf/ts-lock ]]; then
    echo "[DEBUG][run] Starting tailscale..."
    $StartupConf/ts.sh || echo "[ERROR] Unhandled exception: $StartupConf/ts.sh returned $?"
fi
