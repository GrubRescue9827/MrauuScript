#!/bin/bash

if ! pgrep -x tailscaled > /dev/null
    then
        $warn "[WARN][startup-ts] Tailscale Daemon is not running! Attempting to enable with systemctl..."
        systemctl enable tailscaled
        systemctl start tailscaled
fi

if [[ "$(tailscale status)" == *"Logged out."* ]]; then
	$fatal "[FATAL][startup-ts] You are not logged into Tailscale!"
	exit 1
else
	tailscale up
fi
