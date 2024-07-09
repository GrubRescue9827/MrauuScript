#!/bin/bash
# Global configuration file for MrauuScript.
# Place this file in /root/.config/MrauuScript/globals.sh
#
# Note: This approach to configuration is probably really bad
# for performance since even unused directories are calculated
# at runtime.
#
# However a better solution requires a brain, which I do not have.



#
# DIRECTORY CONFIGURATION
#

# Install location of the base MrauuScript folder.
MrauuInstall=/opt/MrauuScript

# Relative paths. These shouldn't need to be changed.
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
plupdate=$updatepluginsconf/manual.sh
stop=$MrauuInstall/stop.sh
run=$MrauuInstall/run.sh
srvmsg=$MrauuInstall/servermsg.sh
BackupCommand=$MrauuInstall/mcbackup.sh



#
# BACKUP CONFIGURATION
#

BackupLoc=""
BackupName=MC-Backup-$(date +"%Y-%m-%d-%H-%M-%S").tar.gz
BackupKeepLast=""



#
# MISCELLANEOUS SERVER CONFIGURATION
#

# Startup command for Minecraft Server
javastartup="sudo -u $UnprivilegedUser java -Xms2000M -Xmx3500M --add-modules=jdk.incubator.vector -jar ./server.jar --nogui"

# Username of an unprivileged user, to run the server software.
# MAKE SURE THIS USER CAN:
#     Has AT LEAST read access to the install directory.
#     Has Read/Write/Execute access to the ./bin directory
#     Store files in its ~/.config/ directory
UnprivilegedUser=gameuser

# Update script to use when installing the OS
# Ex: [Debian Based]
#osupgrade=$MrauuUpdateConf/apt.sh
osupgrade=$MrauuUpdateConf/debug.sh

# Used by DiskAlerts, threshhold (in bytes) to trip critical disk space warning.
diskthreshold="4000000000" # 4GB

#
# UPGRADE CONFIGURATION
#

ServerType=purpur
getlatestver=$updateserverconf/latest-$ServerType.sh
# Command to get current MC server version. Likely doesn't change.
#javaverget="echo [WARN] Server does not support getting current version."
javaverget="$javastartup --version"
MCCurrentVer="latest"
pluginslist=$updatepluginsconf/plugins.csv



#
# DEBUG/DEVTOOLS
#

# Logging levels. Determines what commmand or script will be placed in front of a string to be logged.

# Ex: $error "[ERROR][script] Something went wrong!"
# If $error = echo , this simply prints the error to the screen.

# An example script is included to send notifications to a Discord webhook.
#fatal="$AlertConf/alertadmin.sh"

debug="echo"
info="echo"
warn="echo"
syswarn="echo" # "System Warning" - Any hardware releated warning that isn't the result of programmer error. Currently only used by DiskAlerts.
error="echo"
fatal="echo"
