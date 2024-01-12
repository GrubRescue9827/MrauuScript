#!/bin/bash

selection=$1

case "$selection" in
  "" | "1" | "mc" | "m" | "M" | "minecraft")
sudo screen -r "minecraft" || echo "[ERROR][mcconsole] Returned: $? (Is the server running?)";;
  "2" | "ltn" | "l" | "L" | "localtonet")
sudo screen -r "localtonet" || echo "[ERROR][mcconsole] Returned: $? (Is localtonet running?)";;
  "3" | "ngk" | "n" | "N" | "ngrok")
sudo screen -r "ngrok" || echo "[ERROR][mcconsole] Returned: $? (Is ngrok running?)";;
  *)
echo "[FATAL][mcconsole] Unknown selection \"$selection\"";;
esac
