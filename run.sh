#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][run] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/run"
source $BargsLoc "$@"

function runmc () {
    if pgrep -x "java" > /dev/null
    then
        $info "[INFO][run] Process already running: java"
        if [ "$force_restart" == "y" ]; then
            $stop -r "Restarting in " -s $torun
        else
            userwarn=1
            return
        fi
    fi
    $info "[INFO][run] Starting Server..."
    $StartupConf/mc.sh || $error "[ERROR][run] Unhandled exception: $StartupConf/mc.sh returned $?"
}

function runltn () {
    if [[ ! -f $AlertConf/ltn-auth ]]; then
        return
    fi

    if pgrep -x "localtonet" > /dev/null
    then
        $info "[INFO][run] Process already running: localtonet"
        if [ "$force_restart" == "y" ]; then
            sudo pkill localtonet
        else
            userwarn=1
            return
        fi
    fi
    $info "[INFO][run] Starting localtonet..."
    $StartupConf/localtonet.sh || $error "[ERROR][run] Unhandled exception: $StartupConf/localtonet.sh returned $?"
}

function runngk () {
    if [[ ! -f $AlertConf/ngk-auth ]]; then
        return
    fi

    if pgrep -x "ngrok" > /dev/null
    then
        $info "[INFO][run] Process already running: ngrok"
        if [ "$force_restart" == "y" ]; then
            sudo pkill ngrok
        else
            userwarn=1
            return
        fi
    fi
    $info "[INFO][run] Starting ngrok..."
    $StartupConf/ngrok.sh || $error "[ERROR][run] Unhandled exception: $StartupConf/ngrok.sh returned $?"
}

function runts () {
    if [[ ! -f $StartupConf/ts-lock ]]; then
        return
    fi

    if pgrep -x "tailscaled" > /dev/null
    then
        $info "[INFO][run] Process already running: tailscale"
        if [ "$force_restart" == "y" ]; then
            sudo tailscale down
        else
            userwarn=1
            return
        fi
    fi
    $info "[INFO][run] Starting tailscale..."
    $StartupConf/ts.sh || $error "[ERROR][run] Unhandled exception: $StartupConf/ts.sh returned $?"
}

function runwg () {
    #if [[ ! -f $StartupConf/wg-conf ]]; then
        #return
    #fi

    if [[ -z "$(wg show)" ]]; then
        $info "[INFO][run] Process already running: wireguard"
        if [ "$force_restart" == "y" ]; then
            sudo wg-quick down $(cat $StartupConf/wg-conf)
        else
            userwarn=1
            return
        fi
    fi
    $info "[INFO][run] Starting wireguard..."
    sudo wg-quick up $(cat $StartupConf/wg-conf) || $error "[ERROR][run] Unhandled exception: wg-quick returned $?"
}


case "$torun" in
    all)
        runmc
        runltn
        runngk
        runts
	runwg
        ;;
    netonly)
        runltn
        runngk
        runts
	runwg
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
    wg)
        runwg
        ;;
    *)
        $error "[ERROR][run] Invalid process name: $torun"
        ;;
esac

if [[ "$userwarn" == 1 ]]; then
    $info "[INFO][run] One or more processes were not restarted because --force_restart was not specified."
fi
