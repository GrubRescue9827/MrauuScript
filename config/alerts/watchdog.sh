#!/bin/bash

source ~/.config/MrauuScript/globals.sh

ngktmp=$AlertConf/.ngk.tmp
ltntmp=$AlertConf/.ltn.tmp

if [[ ! -f $ngktmp ]]; then
    echo "[WARN][watchdog] ngrok temp file was not found! Attempting to create..."
    touch $ngktmp
fi
if [[ ! -f $ltntmp ]]; then
    echo "[WARN][watchdog] localtonet temp file was not found! Attempting to create..."
    touch $ltntmp
fi

checkngk () {
if [ ! "$ngk" == "" ]; then
    parsedngk=$(echo $ngk | jq . | jq ".tunnels[].public_url" |  tr -d \" | cut -c 7-)
    if [[ "$parsedngk" == *":"* ]]; then
        if [ ! "$(cat $ngktmp)" == "$parsedngk" ]; then
            echo $parsedngk > $ngktmp
            echo "[INFO][watchdog] !! ngrok IP or port has changed !!"
            ngkchanged=1
        else
            echo "[INFO][watchdog] ngrok IP or port has not changed."
        fi
    else
        echo "[ERROR][watchdog] Error occured when parsing response from Ngrok! See below for details..."
        echo "[ERROR][watchdog] Parsed:"
        echo "$parsedngk"
        echo "[ERROR][watchdog] From JSON response:"
        echo "$ngk"
    fi
else
    echo "[ERROR][watchdog] ngrok returned empty response!"
fi
}

checkltn () {
if [ ! "$ltn" == "" ]; then
    parsedltn=$(echo $ltn | jq . | jq ".result[].serverIp,.result[].serverPort" | tr -d \" | tr '\n' ':' | head -c -1)
    if [[ "$parsedltn" == *":"* ]]; then
        if [ ! "$(cat $ltntmp)" == "$parsedltn" ]; then
            echo $parsedltn > $ltntmp
            echo "[INFO][watchdog] !! localtonet IP or port has changed !!"
            ltnchanged=1
        else
            echo "[INFO][watchdog] localtonet IP or port has not changed."
        fi
    else
        echo "[ERROR][watchdog] Error occured when parsing response from localtonet! See below for details..."
        echo "[ERROR][watchdog] Parsed:"
        echo "$parsedltn"
        echo "[ERROR][watchdog] From JSON response:"
        echo "$ltn"
    fi
else
    echo "[ERROR][watchdog] localtonet returned empty response!"
fi
}

# ngrok
if [[ -f $AlertConf/ngk-auth ]]; then
    if pgrep -x ngrok > /dev/null
    then
        echo "[INFO][watchdog] Getting IP from ngrok..."
        ngk=$($AlertConf/wd-ngk.sh)
        checkngk
    else
        echo "[WARN][watchdog] ngrok is not running!"
        ngknorun=1
    fi
fi

# localtonet
if [[ -f $AlertConf/ltn-auth ]]; then
    if pgrep -x localtonet > /dev/null
    then
        echo "[INFO][watchdog] Getting IP from localtonet..."
        ltn=$($AlertConf/wd-ltn.sh)
        checkltn
    else
        echo "[WARN][watchdog] localtonet is not running!"
        ltnnorun=1
    fi
fi

if [[ ! -z "$ngknorun" && "$ltnnorun" ]]; then
    echo "[ERROR][watchdog] No available sources."
    exit 1
fi

if [[ ! -z "$ngkchanged" && "$ltnchanged" ]]; then
    echo both changed!
    $AlertConf/alert.sh -1 "$parsedngk" -2 "$parsedltn" -c admin
fi
