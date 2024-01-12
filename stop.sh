#!/bin/bash


source ~/.config/MrauuScript/globals.sh

export BARGS_VARS_PATH="$MrauuConfig/stop"
source $BargsLoc "$@"

# Check if server is already stopped
if pgrep -x "java" > /dev/null
then
    echo "[DEBUG][stop] Server is running."
else
    echo "[WARN][stop] Server is not running. Why are you attempting to stop it?"
    exit 1
fi

if [ $append_graceperiod == y ]; then
    text=$reason$graceperiod"s"
else
    text=$reason
fi

echo "[INFO][stop] Shutting down with reason: $reason"

# Forced shutdown
if [ $force == "y" ]; then
    echo "[INFO][stop] Flag force was called, shutting down immediately!"
    $srvmsg -m "stop" -e "y"
fi

# Initial warning message
echo "[INFO][stop] Shutdown message sent to server chat."
$srvmsg -m "$text"

if [ $force == "n" ]; then
    echo "[INFO][stop] Waiting for grace period to end..."
    sleep $graceperiod
fi

# Mercy countdown
if [ $enable_mercycountdown == y ]; then
    for s in {5..1}
    do
        echo "[INFO][stop] Mercy countdown: $s"
        text="Shutting down in $s seconds..."
        $srvmsg -m "$text"
        sleep 1
    done
fi

# Final message. May never actually be viewed by the player.
text="Goodbye~!"
$srvmsg -m "$text"

# Finally, actually stop the server.
echo "[INFO][stop] Sending shutdown signal..."
$srvmsg -m "stop" -e "y"

# Turn off Localtonet or Ngrok
processes=("localtonet" "ngrok" "tailscale")
for pname in "${processes[@]}"; do
    echo "[WARN][stop] Forcefully killing process: $pname"
    pkill $pname
done

# See if server has stopped yet. if not, warn user.
while pgrep -x "java" > /dev/null
do
    for s in {1..30}
    do
        pgrep -x "java" > /dev/null || break
        if [ $s == 30 ]; then
            echo "[ERROR][stop] Server did not respond to shutdown signal. (Is the shutdown command correct?)"
        elif [ $s -gt 5 ]; then
            echo "[WARN][stop] Server is taking a long time to stop! (Try $s of 30)"
        fi
        sleep 1
    done
    exit
done

