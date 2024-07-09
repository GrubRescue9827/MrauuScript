#!/bin/bash

# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][alert] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/alert"
source $BargsLoc "$@"

webhook=$(cat $AlertConf/$channel)
echo $webhook

if [[ ! -z $line1 && ! -z $line2 ]]; then
    payload=$(echo -n -e "{\"content\": \"")$(echo -n \`$line1\`\\n\`$line2\`)$(echo -n -e "\"}")
elif [[ ! -z $line1 ]]; then
    payload=$(echo -n -e "{\"content\": \"")$(echo -n -e \`$line1\`)$(echo -n -e "\"}")
else
    $fatal "[FATAL][alert] Required argument not found."
fi

echo "[INFO][alert] Sending alert..."
response=$(curl -sS -o /dev/null -i -w "%{http_code}\n"  -H 'Accept: application/json' -H 'Content-Type:application/json' -X POST --data "$payload" $webhook)

if [ ! "$response" == "204" ]; then
    if [[ -z $response ]]; then
        $error "[ERROR][alert] cURL returned no response!"
    else
        $error "[ERROR][alert] Unrecognized response: $response"
    fi
fi
