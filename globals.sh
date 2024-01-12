#!/bin/bash

MrauuInstall=/opt/MrauuScript

bin=$MrauuInstall/bin
MCInstall=$bin/mc-server
MrauuConfig=$MrauuInstall/config
BargsLoc=$MrauuConfig/bargs.sh

MrauuUpdateConf=$MrauuConfig/update
mcupdate=Unused?
MrauuPluginConf=$MrauuConfig/plugin
StartupConf=$MrauuConfig/startup
AlertConf=$MrauuConfig/alerts



osupgrade=$MrauuUpdateConf/debug.sh
plupdate=$MrauuPluginConf/plupdate.sh
stop=$MrauuInstall/stop.sh
run=$MrauuInstall/run.sh
srvmsg=$MrauuInstall/servermsg.sh
BackupCommand=$MrauuInstall/mcbackup.sh


UnprivilegedUser=gameuser
BackupLoc=/mnt/backup/
BackupName=MC-Backup-$(date +"%Y-%m-%d-%H-%M-%S").tar.gz

