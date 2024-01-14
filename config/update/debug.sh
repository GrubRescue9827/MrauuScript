 #!/bin/bash

# Debugging example. Useful if you want to skip updating the OS but don't want to use --skip_os_upgrade
echo "###############################################"
echo "#                                             #"
echo "# [WARN] OS Update command is not configured! #"
echo "#                                             #"
echo "###############################################"
echo
for i in $(seq 5 -1 1);
do
    echo "[WARN] Continuing anyway in $i seconds... Press CTRL+C to abort."
    sleep 1
done
