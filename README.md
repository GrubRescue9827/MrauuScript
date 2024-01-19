# MrauuScript
![https://github.com/GrubRescue9827/MrauuScript](./docs/assets/logo.png "https://github.com/GrubRescue9827/MrauuScript")

 **Minecraft Routine Automated Updates & Utilities** (Pronounced: "MrowScript") is a collection of various BASH scripts designed to make administering a Minecraft server easier.

 ![Static Badge](https://img.shields.io/badge/Made_With-BASH-red?style=flat) ![Static Badge](https://img.shields.io/badge/Made_By-FEMBOYS-purple?style=flat)


 [![forthebadge](https://forthebadge.com/images/badges/0-percent-optimized.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/contains-tasty-spaghetti-code.svg)](https://forthebadge.com)

## Features
* Modular design for flexibility
* Automatic updates for plugins*, server*, and OS
* "Soft" server shutdown
* Easily send messages to server chat from command line
* Automatic startup
* Automatic backups
* Optional alerts with ngrok and LocalToNet
* Optional Tailscale automatic startup

#### NOTES:
* Automatic server updates only applicable for Purpur servers. (Relies on the download URL supporting "latest" as a valid version/build.)
* Automatic plugin updates are psudo-manual. (Enter URL, script blindly downloads it regardless of if an update is needed or not.)

Until someone makes a system for managing plugins that works _reliably_, this is the best solution I can come up with. As a temporary solution, you can use [pluGET](https://github.com/Neocky/pluGET) in conjunction with MrauuScript via some [manual configuration.](./config/pluGET)
However, in my experience I found pluGET to be unreliable with certain plugins. Which is due to no fault by the dev, btw! Such a shame, as it works really well for like 90% of my plugins...

## Roadmap - Planned functionality
* Better configuration documentation
* Automatic installer script (Manual install is too tedious! QwQ)
* Test Microsoft Windows compatibility (or lack thereof?)
* Automatic MrauuScript update installer
* Support auto-updating ngrok or localtonet? / Support system packages
* More extensive documentation regarding non-standard setups

# Automatic Installation
To be implemented

# Manual Install
See [Installation Instructions](./docs/install.md)
