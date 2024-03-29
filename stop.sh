#!/bin/bash


# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    echo "[FATAL][stop] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/stop"
source $BargsLoc "$@"

function stopmc () {
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
}

function stopltn () {
    echo "[WARN] Forcefully killing localtonet!"
    sudo pkill localtonet
}

function stopngk () {
    echo "[WARN] Forcefully killing ngrok!"
    sudo pkill ngrok
}

function stopts () {
    sudo tailscale down
}

case "$tostop" in
    all)
        stopmc
        stopltn
        stopngk
        stopts
        ;;
    netonly)
        stopltn
        stopngk
        stopts
        ;;
    mc)
        stopmc
        ;;
    ngk)
        stopngk
        ;;
    ltn)
        stopltn
        ;;
    ts)
        stopts
        ;;
    *)
        echo "[ERROR] Invalid process name: $tostop"
        ;;
esac
