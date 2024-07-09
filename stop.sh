#!/bin/bash


# Check for global config file
globals="/etc/opt/MrauuScript/globals.sh"
if [[ -f $globals ]]; then
    source $globals
else
    $fatal "[FATAL][stop] Config file not found: $globals"
    exit 1
fi

export BARGS_VARS_PATH="$MrauuConfig/stop"
source $BargsLoc "$@"

function stopmc () {
# Check if server is already stopped
if pgrep -x "java" > /dev/null
then
    $debug "[DEBUG][stop] Server is running."
else
    $warn "[WARN][stop] Server is not running. Why are you attempting to stop it?"
    exit 1
fi

if [ $append_graceperiod == y ]; then
    text=$reason$graceperiod"s"
else
    text=$reason
fi

$info "[INFO][stop] Shutting down with reason: $reason"

# Forced shutdown
if [ $force == "y" ]; then
    $info "[INFO][stop] Flag force was called, shutting down immediately!"
    $srvmsg -m "stop" -e "y"
fi

# Initial warning message
echo "[INFO][stop] Shutdown message sent to server chat."
$srvmsg -m "$text"

if [ $force == "n" ]; then
    $info "[INFO][stop] Waiting for grace period to end..."
    sleep $graceperiod
fi

# Mercy countdown
if [ $enable_mercycountdown == y ]; then
    for s in {5..1}
    do
        $info "[INFO][stop] Mercy countdown: $s"
        text="Shutting down in $s seconds..."
        $srvmsg -m "$text"
        sleep 1
    done
fi

# Final message. May never actually be viewed by the player.
text="Goodbye~!"
$srvmsg -m "$text"

# Finally, actually stop the server.
$info "[INFO][stop] Sending shutdown signal..."
$srvmsg -m "stop" -e "y"

# See if server has stopped yet. if not, warn user.
while pgrep -x "java" > /dev/null
do
    for s in {1..30}
    do
        pgrep -x "java" > /dev/null || break
        if [ $s == 30 ]; then
            $error "[ERROR][stop] Server did not respond to shutdown signal. (Is the shutdown command correct?)"
        elif [ $s -gt 5 ]; then
            $warn "[WARN][stop] Server is taking a long time to stop! (Try $s of 30)"
        fi
        sleep 1
    done
    exit
done
}

function stopltn () {
    $warn "[WARN][stop] Forcefully killing localtonet!"
    sudo pkill localtonet
}

function stopngk () {
    $warn "[WARN][stop] Forcefully killing ngrok!"
    sudo pkill ngrok
}

function stopts () {
    sudo tailscale down
}

function stopwg () {
    sudo wg-quick down $(cat $StartupConf/wg-conf)
}

case "$tostop" in
    all)
        stopmc
        stopltn
        stopngk
        stopts
	stopwg
        ;;
    netonly)
        stopltn
        stopngk
        stopts
	stopwg
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
    wg)
	stopwg
	;;
    *)
        $error "[ERROR][stop] Invalid process name: $tostop"
        ;;
esac
