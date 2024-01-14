# Configuration
MrauuScript mostly relies on BARGS as well as a global config file for configuration. Default config files can be found in ./config/

## Global config file

Directories, script locations, and any other variable that is used more than once is stored in the global "config" file `/root/.config/MrauuScript/globals.sh`
This file creates variables that are used in multiple scripts.

```bash
# !! This is an excerpt and should NOT be used as a default config. !!

# Install location of the MrauuScript folder.
MrauuInstall=/opt/MrauuScript

# Username of an unprivileged user, to run the server software.
# MAKE SURE THIS USER CAN:
#     Has AT LEAST read access to the install directory.
#     Has Read/Write/Execute access to the ./bin directory
#     Store files in its ~/.config/ directory
UnprivilegedUser=gameuser

# Backup configuration
BackupLoc=/mnt/backup/
BackupName=MC-Backup-$(date +"%Y-%m-%d-%H-%M-%S").tar.gz
```

The most important settings to change here are:
- `osupgrade` Defines what script to use when updating the OS. See the [update folder](../config/update/) for a list of options, or [make your own
](./config-advanced) if your prefered package manager isn't listed.
- `MrauuInstall` Defines the install location of the MrauuScript folder. All subsequent folders should use relative pathing from this folder by default.


## Per-Script config

All configurable options can be easily accessed via command line arguments. You can see all available command line arguments for a specific script using the argument `--help`. Once you have a setting locked in, you can ***set its value under `default=` in the appropriate configuration file.***

```
---
name=example
short=e
default="Place your configured option here"
description=Do not change this!
---
name=bargs
description=Do not change this!
default=irrelevant
---
---
```

#### Notes:
- ⚠️ BARGS seems to have issues interpreting quotes, even if they are backslash-escaped!
- ⚠️ BARGS cannot handle config files with a file extension.

## Custom Scripts
In addition, MrauuScript can also be configured to use custom scripts or commands for all of its functions. This can be used to better suit your specific needs. See [Advanced Configuration](./config-advanced.md) for more detailed information.

## Alerts
See [Configuring Alerts](./config-alerts.md).
