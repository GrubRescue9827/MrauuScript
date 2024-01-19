#!/bin/bash
# Global configuration file for MrauuScript. 
# Place this file in /root/.config/MrauuScript/globals.sh
#
# Note: This approach to configuration is probably really bad
# for performance since even unused directories are calculated
# at runtime.
#
# However a better solution requires a brain, which I do not have.


# Install location of the MrauuScript folder.
MrauuInstall=/opt/MrauuScript

# Relative paths. These should not need to be changed 
# if you're just moving the install location above.
bin=$MrauuInstall/bin
MCInstall=$bin/mc-server
MrauuConfig=$MrauuInstall/config
BargsLoc=$MrauuConfig/bargs.sh
MrauuUpdateConf=$MrauuConfig/update
MrauuPluginConf=$MrauuConfig/plugin
StartupConf=$MrauuConfig/startup
AlertConf=$MrauuConfig/alerts
updatepluginsconf=$MrauuUpdateConf/plugins
updateserverconf=$MrauuUpdateConf/server
downloadconf=$MrauuUpdateConf/download

# Replace debug.sh with your package manager of choice!
# Make sure a valid update script exists in the
# ./config/update/ folder
osupgrade=$MrauuUpdateConf/debug.sh

# Other script directories. Do not edit if you don't know what you're doing!
plupdate=$updatepluginsconf/manual.sh
stop=$MrauuInstall/stop.sh
run=$MrauuInstall/run.sh
srvmsg=$MrauuInstall/servermsg.sh
BackupCommand=$MrauuInstall/mcbackup.sh

# Command to get the latest version and build of MC server.
getlatestver=$updateserverconf/latest-purpur.sh

# Username of an unprivileged user, to run the server software.
# MAKE SURE THIS USER CAN:
#     Has AT LEAST read access to the install directory.
#     Has Read/Write/Execute access to the ./bin directory
#     Store files in its ~/.config/ directory
UnprivilegedUser=gameuser

# Backup configuration
BackupLoc=/mnt/backup/
BackupName=MC-Backup-$(date +"%Y-%m-%d-%H-%M-%S").tar.gz

# Startup command for Minecraft Server
javastartup="sudo -u $UnprivilegedUser java -Xms2000M -Xmx3500M --add-modules=jdk.incubator.vector -jar ./server.jar --nogui"

# Command to get current MC server version.
javaverget="$javastartup --version"

# Upgrade configuration.
MCCurrentVer="latest"
pluginslist=$updatepluginsconf/plugins.csv
