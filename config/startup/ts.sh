#!/bin/bash

if ! pgrep -x tailscaled > /dev/null
    then
        echo "[WARN][startup-ts] Tailscale Daemon is not running! Attempting to enable with systemctl..."
        systemctl enable tailscaled
        systemctl start tailscaled
fi

if [[ "$(tailscale status)" == *"Logged out."* ]]; then
	echo "[FATAL][startup-ts] You are not logged into Tailscale!"
	exit 1
else
	tailscale up
fi
