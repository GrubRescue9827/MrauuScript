#!/bin/bash

source ~/.config/MrauuScript/globals.sh

export BARGS_VARS_PATH="$MrauuConfig/alert"
source $BargsLoc "$@"

webhook=$(cat $AlertConf/$channel)
echo $webhook

if [[ ! -z $line1 && ! -z $line2 ]]; then
    payload=$(echo -n -e "{\"content\": \"")$(echo -n \# \:warning\: New IP\(s\)\! \:warning\:\\n)$(echo -n -e \#\# \<\:jva0\:1158592565436751942\>\<\:jva1\:1158592563729682452\>\<\:jva2\:1158592561431183390\> \`$line1\`)$(echo -n \\n)$(echo -n -e \#\# \<\:brk0\:1158592824950931457\>\<\:brk1\:1158592823872983153\>\<\:brk2\:1158592822744731718\>\<\:brk3\:1158592820437852240\> \`$line2\`)$(echo -n -e "\"}")
    #payload=$(echo -n -e "{\"content\": \"")$(echo -n \`$line1\`\\n\`$line2\`)$(echo -n -e "\"}")
elif [[ ! -z $line1 ]]; then
    payload=$(echo -n -e "{\"content\": \"")$(echo -n -e \`$line1\`)$(echo -n -e "\"}")
else
    echo "[FATAL][alert] Required argument not found."
fi

echo "[INFO][alert] Sending alert..."
response=$(curl -sS -o /dev/null -i -w "%{http_code}\n"  -H 'Accept: application/json' -H 'Content-Type:application/json' -X POST --data "$payload" $webhook)

if [ ! "$response" == "204" ]; then
    if [[ -z $response ]]; then
        echo "[ERROR][alert] cURL returned no response!"
    else
        echo "[ERROR][alert] Unrecognized response: $response"
    fi
fi
