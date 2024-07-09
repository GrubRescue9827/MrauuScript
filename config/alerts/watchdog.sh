#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][watchdog] Config file not found: $globals"
    exit 1
fi

ngktmp=$AlertConf/.ngk.tmp
ltntmp=$AlertConf/.ltn.tmp

if [[ ! -f $ngktmp ]]; then
    $warn "[WARN][watchdog] ngrok temp file was not found! Attempting to create..."
    touch $ngktmp
fi
if [[ ! -f $ltntmp ]]; then
    $warn "[WARN][watchdog] localtonet temp file was not found! Attempting to create..."
    touch $ltntmp
fi

checkngk () {
if [ ! "$ngk" == "" ]; then
    parsedngk=$(echo $ngk | jq . | jq ".tunnels[].public_url" |  tr -d \" | cut -c 7-)
    if [[ "$parsedngk" == *":"* ]]; then
        if [ ! "$(cat $ngktmp)" == "$parsedngk" ]; then
            echo $parsedngk > $ngktmp
            $info "[INFO][watchdog] !! ngrok IP or port has changed !!"
            ngkchanged=1
        else
            $info "[INFO][watchdog] ngrok IP or port has not changed."
        fi
    else
        $error "[ERROR][watchdog] Error occured when parsing response from Ngrok! See below for details..."
        $error "[ERROR][watchdog] Parsed:"
        $error "$parsedngk"
        $error "[ERROR][watchdog] From JSON response:"
        $error "$ngk"
        ngkerror=1
    fi
else
    $error "[ERROR][watchdog] ngrok returned empty response!"
    ngkerror=1
fi
}

checkltn () {
if [ ! "$ltn" == "" ]; then
    parsedltn=$(echo $ltn | jq . | jq ".result[].serverIp,.result[].serverPort" | tr -d \" | tr '\n' ':' | head -c -1)
    if [[ "$parsedltn" == *":"* ]]; then
        if [ ! "$(cat $ltntmp)" == "$parsedltn" ]; then
            echo $parsedltn > $ltntmp
            $info "[INFO][watchdog] !! localtonet IP or port has changed !!"
            ltnchanged=1
        else
            $info "[INFO][watchdog] localtonet IP or port has not changed."
        fi
    else
        $error "[ERROR][watchdog] Error occured when parsing response from localtonet! See below for details..."
        $error "[ERROR][watchdog] Parsed:"
        $error "$parsedltn"
        $error "[ERROR][watchdog] From JSON response:"
        $error "$ltn"
        ltnerror=1
    fi
else
    $error "[ERROR][watchdog] localtonet returned empty response!"
    ltnerror=1
fi
}

# Check ngrok if configured
if [[ -f $AlertConf/ngk-auth ]]; then
    if pgrep -x ngrok > /dev/null
    then
        $info "[INFO][watchdog] Getting IP from ngrok..."
        ngk=$($AlertConf/wd-ngk.sh)
        checkngk
    else
        $warn "[WARN][watchdog] ngrok is not running!"
        ngkerror=1
    fi
fi

# Check localtonet if configured
if [[ -f $AlertConf/ltn-auth ]]; then
    if pgrep -x localtonet > /dev/null
    then
        $info "[INFO][watchdog] Getting IP from localtonet..."
        ltn=$($AlertConf/wd-ltn.sh)
        checkltn
    else
        $warn "[WARN][watchdog] localtonet is not running!"
        ltnerror=1
    fi
fi

if [[ ! -z "$ngkerror" && "$ltnerror" ]]; then
    $fatal "[FATAL][watchdog] No available sources to check, or all sources returned errors. ABORT!"
    exit 1
fi

# If both LTN and NGK are installed, but one has an error, then replace its empty parsed string with an error msg
# The nested ifs are bad with this one, but I do not care.
# TODO: Add support for only one being installed.
if [[ -f $AlertConf/ngk-auth && -f $AlertConf/ltn-auth ]]; then

    # Ignore offline sources
    if [[ ! -z $ltnerror || $ngkerror ]]; then
        parseerror="Offline"
        if [[ -z $parsedngk ]]; then
            parsedngk=$parseerror
            echo $parsedngk > $ngktmp
        fi
        if [[ -z $parsedltn ]]; then
            parsedltn=$parseerror
            echo $parsedltn > $ltntmp
        fi
    fi

    # If one or more have been changed, send an alert.
    if [[ ! -z "$ngkchanged" || "$ltnchanged" ]]; then
        $info "[INFO][watchdog] One or more IPs have changed!"
        $AlertConf/alert.sh -1 "$parsedngk" -2 "$parsedltn" -c webhook
    fi
fi
