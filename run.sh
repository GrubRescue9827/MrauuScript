#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][run] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/run"
source $BargsLoc "$@"

function runmc () {
    if pgrep -x "java" > /dev/null
    then
        echo "[WARN] Process already running: java"
        if [ "$force_restart" == "y" ]; then
            $stop -r "Restarting in " -s $torun
        else
            warn=1
            return
        fi
    fi
    echo "[INFO] Starting Server..."
    $StartupConf/mc.sh || echo "[ERROR] Unhandled exception: $StartupConf/mc.sh returned $?"
}

function runltn () {
    if [[ ! -f $AlertConf/ltn-auth ]]; then
        return
    fi

    if pgrep -x "localtonet" > /dev/null
    then
        echo "[WARN] Process already running: localtonet"
        if [ "$force_restart" == "y" ]; then
            sudo pkill localtonet
        else
            warn=1
            return
        fi
    fi
    echo "[INFO] Starting localtonet..."
    $StartupConf/localtonet.sh || echo "[ERROR] Unhandled exception: $StartupConf/localtonet.sh returned $?"
}

function runngk () {
    if [[ ! -f $AlertConf/ngk-auth ]]; then
        return
    fi

    if pgrep -x "ngrok" > /dev/null
    then
        echo "[WARN] Process already running: ngrok"
        if [ "$force_restart" == "y" ]; then
            sudo pkill ngrok
        else
            warn=1
            return
        fi
    fi
    echo "[INFO] Starting ngrok..."
    $StartupConf/ngrok.sh || echo "[ERROR] Unhandled exception: $StartupConf/ngrok.sh returned $?"
}

function runts () {
    if [[ ! -f $StartupConf/ts-lock ]]; then
        return
    fi

    if pgrep -x "tailscaled" > /dev/null
    then
        echo "[WARN] Process already running: tailscale"
        if [ "$force_restart" == "y" ]; then
            sudo tailscale down
        else
            warn=1
            return
        fi
    fi
    echo "[INFO] Starting tailscale..."
    $StartupConf/ts.sh || echo "[ERROR] Unhandled exception: $StartupConf/ts.sh returned $?"
}


case "$torun" in
    all)
        runmc
        runltn
        runngk
        runts
        ;;
    netonly)
        runltn
        runngk
        runts
        ;;
    mc)
        runmc
        ;;
    ngk)
        runngk
        ;;
    ltn)
        runltn
        ;;
    ts)
        runts
        ;;
    *)
        echo "[ERROR] Invalid process name: $torun"
        ;;
esac

if [[ "$warn" == 1 ]]; then
    echo "[ERROR] One or more processes were not restarted because --force_restart was not specified."
fi
